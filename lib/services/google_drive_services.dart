import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class GoogleDriveService {
  static const _scopes = [drive.DriveApi.driveFileScope];

  // --- keep your exact sign-in flow ---
  static Future<drive.DriveApi> getDriveClient() async {
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();

    GoogleSignInAccount? acct = await googleSignIn.attemptLightweightAuthentication();
    acct ??= await googleSignIn.authenticate();
    if (acct == null) {
      throw Exception('User cancelled Google Sign-In');
    }

    final auth = await googleSignIn.authorizationClient?.authorizeScopes(_scopes);
    if (auth == null) {
      throw Exception('Failed to authorize scopes');
    }

    final token = auth.accessToken;
    if (token == null) {
      throw Exception('Access token is null');
    }

    final client = _AuthClient(token);
    return drive.DriveApi(client);
  }

  // --- your original simple uploader (unchanged) ---
  static Future<String> uploadFile({
    required File file,
    String? folderId,
  }) async {
    final api = await getDriveClient();

    final metadata = drive.File()
      ..name = file.uri.pathSegments.last
      ..parents = folderId != null ? [folderId] : null;

    final media = drive.Media(file.openRead(), await file.length());

    final result = await api.files.create(
      metadata,
      uploadMedia: media,
      $fields: 'id, webViewLink',
      supportsAllDrives: true,
    );

    return result.webViewLink ?? '';
  }

  // ---------------------------------------------------------------------------
  // NEW: Upload a whole bundle into a SHARED DRIVE:
  //   <SharedDriveRoot>/<parentFolderName>/<username>/<contractId>/
  // Uploads:
  //   • JSON snapshot of contractData  ( "<username> - <contractId>.json" )
  //   • Multiple images from local paths and/or raw bytes (prefixed with username)
  // ---------------------------------------------------------------------------
  static Future<DriveBundleResult> uploadContractBundleToSharedDrive({
    required String sharedDriveId,                // the Shared Drive *Drive ID*
    required String username,                     // used for folder + filename prefix
    required String contractId,                   // subfolder under username
    required Map<String, dynamic> contractData,   // serialized to JSON
    String parentFolderName = 'Contracts',        // top folder in the drive
    Map<String, String>? imageFilePaths,          // label -> local file path
    Map<String, Uint8List>? imageBytes,           // label -> bytes
    bool anyoneCanView = false,
  }) async {
    final api = await getDriveClient();

    // 1) /<parentFolderName> at shared drive root
    final parentId = await _ensureFolderInSharedDrive(
      api: api,
      sharedDriveId: sharedDriveId,
      name: parentFolderName,
      parentId: null,
    );

    // 2) /<parentFolderName>/<username>
    final userFolderId = await _ensureFolderInSharedDrive(
      api: api,
      sharedDriveId: sharedDriveId,
      name: username.trim(),
      parentId: parentId,
    );

    // 3) /<parentFolderName>/<username>/<contractId>
    final contractFolderId = await _ensureFolderInSharedDrive(
      api: api,
      sharedDriveId: sharedDriveId,
      name: contractId,
      parentId: userFolderId,
    );

    final uploaded = <DriveUploadResult>[];

    // 4) JSON snapshot
    final jsonName = _safe('$username - $contractId.json');
    final jsonBytes = Uint8List.fromList(utf8.encode(jsonEncode(contractData)));
    uploaded.add(
      await _uploadBytesToFolder(
        api: api,
        parentId: contractFolderId,
        bytes: jsonBytes,
        filename: jsonName,
        mimeType: 'application/json',
        anyoneCanView: anyoneCanView,
      ),
    );

    // 5) image bytes
    if (imageBytes != null && imageBytes.isNotEmpty) {
      for (final e in imageBytes.entries) {
        final label = _safe(e.key);
        final filename = _safe('$username - $label.png');
        uploaded.add(
          await _uploadBytesToFolder(
            api: api,
            parentId: contractFolderId,
            bytes: e.value,
            filename: filename,
            mimeType: lookupMimeType(filename) ?? 'application/octet-stream',
            anyoneCanView: anyoneCanView,
          ),
        );
      }
    }

    // 6) image files (local paths)
    if (imageFilePaths != null && imageFilePaths.isNotEmpty) {
      for (final e in imageFilePaths.entries) {
        final label = _safe(e.key);
        final path = e.value;
        final ext = path.split('.').last.toLowerCase();
        final filename = _safe('$username - $label.$ext');
        uploaded.add(
          await _uploadFileToFolder(
            api: api,
            parentId: contractFolderId,
            file: File(path),
            filenameOverride: filename,
            anyoneCanView: anyoneCanView,
          ),
        );
      }
    }

    return DriveBundleResult(
      userFolderId: userFolderId,
      contractFolderId: contractFolderId,
      files: uploaded,
    );
  }

  // ---------- helpers ----------
  static Future<String> _ensureFolderInSharedDrive({
    required drive.DriveApi api,
    required String sharedDriveId,
    required String name,
    String? parentId,
  }) async {
    final escaped = _escape(name);
    final parentFilter = parentId != null ? " and '$parentId' in parents" : "";
    final q = "mimeType = 'application/vnd.google-apps.folder' "
        "and name = '$escaped' and trashed = false$parentFilter";

    final list = await api.files.list(
      corpora: 'drive',
      driveId: sharedDriveId,
      includeItemsFromAllDrives: true,
      supportsAllDrives: true,
      q: q,
      $fields: 'files(id,name)',
      pageSize: 1,
      spaces: 'drive',
    );

    if (list.files != null && list.files!.isNotEmpty) {
      return list.files!.first.id!;
    }

    final meta = drive.File()
      ..name = name
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = parentId != null ? [parentId] : null;

    final created = await api.files.create(
      meta,
      supportsAllDrives: true,
      $fields: 'id',
    );
    return created.id!;
  }

  static Future<DriveUploadResult> _uploadFileToFolder({
    required drive.DriveApi api,
    required String parentId,
    required File file,
    required String filenameOverride,
    bool anyoneCanView = false,
  }) async {
    final mime = lookupMimeType(filenameOverride) ?? lookupMimeType(file.path) ?? 'application/octet-stream';

    final meta = drive.File()
      ..name = filenameOverride
      ..mimeType = mime
      ..parents = [parentId];

    final media = drive.Media(file.openRead(), await file.length());

    final created = await api.files.create(
      meta,
      uploadMedia: media,
      supportsAllDrives: true,
      $fields: 'id,name,webViewLink,parents',
    );

    if (anyoneCanView) {
      await api.permissions.create(
        drive.Permission()
          ..type = 'anyone'
          ..role = 'reader',
        created.id!,
        supportsAllDrives: true,
      );
    }

    return DriveUploadResult(
      id: created.id!,
      name: created.name ?? filenameOverride,
      webViewLink: created.webViewLink ?? '',
      parentIds: (created.parents ?? const <String>[]),
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

    final created = await api.files.create(
      meta,
      uploadMedia: media,
      supportsAllDrives: true,
      $fields: 'id,name,webViewLink,parents',
    );

    if (anyoneCanView) {
      await api.permissions.create(
        drive.Permission()
          ..type = 'anyone'
          ..role = 'reader',
        created.id!,
        supportsAllDrives: true,
      );
    }

    return DriveUploadResult(
      id: created.id!,
      name: created.name ?? filename,
      webViewLink: created.webViewLink ?? '',
      parentIds: (created.parents ?? const <String>[]),
    );
  }

  static String _escape(String s) => s.replaceAll("'", r"\'");
  static String _safe(String s) => s.replaceAll(RegExp(r'[\\/|:*?"<>]'), '-').trim();
}

// simple result types
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
