import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

/// Google Drive upload helper that supports:
/// - Regular "My Drive" folders
/// - Shared Drive **root** or sub-folders (with proper corpora/driveId handling)
///
///  • Any Uint8List blobs (e.g., signatures) as PNGs
///  • Any local files (photos/videos) by path
class GoogleDriveService {
  // Drive scopes needed for uploading/creating files & folders
  static const List<String> _driveScopes = <String>[
    drive.DriveApi.driveScope,      // full Drive incl. shared drives
    drive.DriveApi.driveFileScope,  // read/write files created by the app
  ];

  /// Build an authenticated Drive client using the **v7** google_sign_in flow.
  static Future<drive.DriveApi> _getDriveClient({
    String? clientId,
    String? serverClientId,
  }) async {
    final signIn = GoogleSignIn.instance;

    await signIn.initialize(clientId: clientId, serverClientId: serverClientId);

    GoogleSignInAccount? user;
    try {
      user = await signIn.attemptLightweightAuthentication();
    } catch (_) {
      // ignore; we'll fall back to interactive auth
    }

    user ??= await signIn.authenticate();

    final authClient = user.authorizationClient;
    var authorization = await authClient.authorizationForScopes(_driveScopes);
    authorization ??= await authClient.authorizeScopes(_driveScopes);

    final accessToken = authorization.accessToken; // v7 way to get access token
    return drive.DriveApi(_AuthClient(accessToken));
  }

  /// Public entry: Upload a "bundle" under a **known folder URL/ID** (My Drive or Shared Drive).
  static Future<DriveBundleResult> uploadContractBundleToFolderLink({
    required String parentFolderLinkOrId, // URL like https://drive.../folders/<ID> or just the ID
    String topFolderName = 'EdWard',
    required String username,
    required String contractId,
    required Map<String, dynamic> contractData,
    Map<String, String>? imageFilePaths,  // label -> local file path
    Map<String, Uint8List>? imageBytes,   // label -> bytes
    bool anyoneCanView = false,
    String? clientId,
    String? serverClientId,
  }) async {
    final api = await _getDriveClient(
      clientId: clientId,
      serverClientId: serverClientId,
    );

    // Resolve whether the input is a Shared Drive root or a folder id in Drive
    final resolved = await _resolveParentContext(api: api, urlOrId: parentFolderLinkOrId);
    final parentId = resolved.parentId;
    final driveId = resolved.driveId; // may be null for "My Drive"

    // Ensure EdWard/<username>/<contractId>
    final rootId = await _ensureFolderUnderParent(
      api: api,
      name: topFolderName,
      parentId: parentId,
      driveId: driveId,
    );
    final userFolderId = await _ensureFolderUnderParent(
      api: api,
      name: username.trim(),
      parentId: rootId,
      driveId: driveId,
    );
    final contractFolderId = await _ensureFolderUnderParent(
      api: api,
      name: contractId,
      parentId: userFolderId,
      driveId: driveId,
    );

    final uploaded = <DriveUploadResult>[];

    // JSON snapshot
    final jsonName = _safe('$username - $contractId.json');
    final jsonBytes = Uint8List.fromList(utf8.encode(jsonEncode(contractData)));
    uploaded.add(await _uploadBytesToFolder(
      api: api,
      parentId: contractFolderId,
      bytes: jsonBytes,
      filename: jsonName,
      mimeType: 'application/json',
      anyoneCanView: anyoneCanView,
    ));

    // Raw byte files (e.g., signatures)
    if (imageBytes != null) {
      for (final e in imageBytes.entries) {
        final filename = _safe('$username - ${e.key}.png');
        uploaded.add(await _uploadBytesToFolder(
          api: api,
          parentId: contractFolderId,
          bytes: e.value,
          filename: filename,
          mimeType: lookupMimeType(filename) ?? 'application/octet-stream',
          anyoneCanView: anyoneCanView,
        ));
      }
    }

    // Local files by path (e.g., photos/videos)
    if (imageFilePaths != null) {
      for (final e in imageFilePaths.entries) {
        final path = e.value;
        final ext = path.split('.').last.toLowerCase();
        final filename = _safe('$username - ${e.key}.$ext');
        uploaded.add(await _uploadFileToFolder(
          api: api,
          parentId: contractFolderId,
          file: File(path),
          filenameOverride: filename,
          anyoneCanView: anyoneCanView,
        ));
      }
    }

    return DriveBundleResult(
      userFolderId: userFolderId,
      contractFolderId: contractFolderId,
      files: uploaded,
    );
  }

  // --------------------------- helpers ---------------------------

  /// Accepts a URL/ID that could be:
  ///  • Shared Drive root ID  → parent = that root id, driveId = same id
  ///  • Folder ID (My Drive or Shared Drive) → parent = folder id, driveId resolved if belongs to a Shared Drive
  static Future<({String parentId, String? driveId})> _resolveParentContext({
    required drive.DriveApi api,
    required String urlOrId,
  }) async {
    final id = _extractDriveIdFromUrl(urlOrId)
        ?? (throw Exception('Bad Drive link/id: $urlOrId'));

    // Try Shared Drive first
    try {
      final drive.Drive drv = await api.drives.get(id) as drive.Drive;
      if (drv.id != null && drv.id!.isNotEmpty) {
        // For Shared Drives, the drive's root folder id equals the drive id.
        return (parentId: drv.id!, driveId: drv.id!);
      }
    } catch (_) {
      // Not a Shared Drive id; continue as folder-id flow.
    }

    // Otherwise treat as a folder id (My Drive or inside a Shared Drive)
    final drive.File f = await api.files.get(
      id,
      supportsAllDrives: true,
      $fields: 'id,mimeType,driveId',
    ) as drive.File;

    final mime = f.mimeType ?? '';
    if (mime != 'application/vnd.google-apps.folder') {
      throw Exception('Provided ID is not a folder (mimeType=$mime).');
    }
    return (parentId: f.id!, driveId: f.driveId);
  }

  static String? _extractDriveIdFromUrl(String urlOrId) {
    if (!urlOrId.contains('/')) return urlOrId.trim();
    final patterns = <RegExp>[
      RegExp(r'/folders/([a-zA-Z0-9_-]+)'),
      RegExp(r'/file/d/([a-zA-Z0-9_-]+)'),
      RegExp(r'[?&]id=([a-zA-Z0-9_-]+)'),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(urlOrId);
      if (m != null) return m.group(1);
    }
    return null;
  }

  /// Creates (if needed) a folder named [name] under [parentId].
  /// If [driveId] is provided, we constrain list queries to that Shared Drive.
  static Future<String> _ensureFolderUnderParent({
    required drive.DriveApi api,
    required String name,
    required String parentId,
    String? driveId, // <-- Shared Drive id when available
  }) async {
    final q =
        "mimeType = 'application/vnd.google-apps.folder' "
        "and name = '${_escape(name)}' and trashed = false "
        "and '$parentId' in parents";

    final drive.FileList list = await api.files.list(
      corpora: driveId != null ? 'drive' : 'user',
      driveId: driveId,
      includeItemsFromAllDrives: true,
      supportsAllDrives: true,
      spaces: 'drive',
      q: q,
      $fields: 'files(id,name)',
      pageSize: 1,
    );

    if (list.files != null && list.files!.isNotEmpty) {
      return list.files!.first.id!;
    }

    final fileMeta = drive.File()
      ..name = name
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = [parentId];

    final drive.File created = await api.files.create(
      fileMeta,
      supportsAllDrives: true,
      $fields: 'id',
    ) as drive.File;

    return created.id!;
  }

  static Future<DriveUploadResult> _uploadFileToFolder({
    required drive.DriveApi api,
    required String parentId,
    required File file,
    required String filenameOverride,
    bool anyoneCanView = false,
  }) async {
    final mime = lookupMimeType(filenameOverride) ??
        lookupMimeType(file.path) ??
        'application/octet-stream';

    final meta = drive.File()
      ..name = filenameOverride
      ..mimeType = mime
      ..parents = [parentId];

    final media = drive.Media(file.openRead(), await file.length());

    final drive.File created = await api.files.create(
      meta,
      uploadMedia: media,
      supportsAllDrives: true,
      $fields: 'id,name,webViewLink,parents',
    ) as drive.File;

    if (anyoneCanView) {
      try {
        await api.permissions.create(
          drive.Permission()
            ..type = 'anyone'
            ..role = 'reader',
          created.id!,
          supportsAllDrives: true,
        );
      } catch (_) {
        // Org policies on Shared Drives may block link-sharing; ignore gracefully.
      }
    }

    return DriveUploadResult(
      id: created.id!,
      name: created.name ?? filenameOverride,
      webViewLink: created.webViewLink ?? '',
      parentIds: created.parents ?? const <String>[],
    );
  }

  static Future<DriveUploadResult> _uploadBytesToFolder({
    required drive.DriveApi api,
    required String parentId,
    required Uint8List bytes,
    required String filename,
    String? mimeType,
    bool anyoneCanView = false,
  }) async {
    final mime = mimeType ?? lookupMimeType(filename) ?? 'application/octet-stream';

    final meta = drive.File()
      ..name = filename
      ..mimeType = mime
      ..parents = [parentId];

    final media = drive.Media(Stream<List<int>>.value(bytes), bytes.length);

    final drive.File created = await api.files.create(
      meta,
      uploadMedia: media,
      supportsAllDrives: true,
      $fields: 'id,name,webViewLink,parents',
    ) as drive.File;

    if (anyoneCanView) {
      try {
        await api.permissions.create(
          drive.Permission()
            ..type = 'anyone'
            ..role = 'reader',
          created.id!,
          supportsAllDrives: true,
        );
      } catch (_) {
        // Org policies on Shared Drives may block link-sharing; ignore gracefully.
      }
    }

    return DriveUploadResult(
      id: created.id!,
      name: created.name ?? filename,
      webViewLink: created.webViewLink ?? '',
      parentIds: created.parents ?? const <String>[],
    );
  }

  static String _escape(String s) => s.replaceAll("'", r"\'");
  static String _safe(String s) =>
      s.replaceAll(RegExp(r'[\\/|:*?"<>]'), '-').trim();
}

// --------------------------- Result types ---------------------------

class DriveBundleResult {
  final String userFolderId;
  final String contractFolderId;
  final List<DriveUploadResult> files;
  DriveBundleResult({
    required this.userFolderId,
    required this.contractFolderId,
    required this.files,
  });
}

class DriveUploadResult {
  final String id;
  final String name;
  final String webViewLink;
  final List<String> parentIds;
  DriveUploadResult({
    required this.id,
    required this.name,
    required this.webViewLink,
    required this.parentIds,
  });
}

// --------------------------- Auth wrapper ---------------------------

/// Auth wrapper that injects the OAuth2 Bearer token into each HTTP request.
class _AuthClient extends http.BaseClient {
  final String _token;
  final http.Client _inner = http.Client();
  _AuthClient(this._token);
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_token';
    return _inner.send(request);
  }
}
