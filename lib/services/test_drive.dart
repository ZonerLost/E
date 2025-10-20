// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:edwardb/services/google_drive_services.dart';
// import 'package:mime/mime.dart';
// import 'package:googleapis/drive/v3.dart' as drive;

// // ---------- Public high-level helper ----------
// class DriveBundleResult {
//   final String userFolderId;
//   final String contractFolderId;
//   final List<DriveUploadResult> files;
//   DriveBundleResult({
//     required this.userFolderId,
//     required this.contractFolderId,
//     required this.files,
//   });
// }

// class DriveUploadResult {
//   final String id;
//   final String name;
//   final String webViewLink;
//   final List<String> parentIds;
//   DriveUploadResult({
//     required this.id,
//     required this.name,
//     required this.webViewLink,
//     required this.parentIds,
//   });
// }

// extension DriveBundle on GoogleDriveService {
//   /// Upload a bundle into a Shared Drive:
//   /// structure: <SharedDriveRoot>/<parentFolderName?>/<username>/<contractId>/
//   /// - JSON file with contractData
//   /// - Multiple image files / bytes
//   static Future<DriveBundleResult> uploadContractBundleToSharedDrive({
//     required String sharedDriveId,      // Shared Drive (Drive) ID
//     required String username,           // folder name + filename prefix
//     required String contractId,         // subfolder name
//     required Map<String, dynamic> contractData,
//     String parentFolderName = 'EdWard',
//     Map<String, String>? imageFilePaths,      // label -> local file path
//     Map<String, Uint8List>? imageBytes,       // label -> bytes
//     bool anyoneCanView = false,
//   }) async {
//     final api = await GoogleDriveService.getDriveClient();

//     // 1) Ensure /Contracts (or your chosen) at Shared Drive root
//     final parentId = await _ensureFolderInSharedDrive(
//       api: api,
//       sharedDriveId: sharedDriveId,
//       name: parentFolderName,
//       parentId: null,
//     );

//     // 2) Ensure /Contracts/<username>
//     final userFolderId = await _ensureFolderInSharedDrive(
//       api: api,
//       sharedDriveId: sharedDriveId,
//       name: username.trim(),
//       parentId: parentId,
//     );

//     // 3) Ensure /Contracts/<username>/<contractId>
//     final contractFolderId = await _ensureFolderInSharedDrive(
//       api: api,
//       sharedDriveId: sharedDriveId,
//       name: contractId,
//       parentId: userFolderId,
//     );

//     final uploaded = <DriveUploadResult>[];

//     // 4) Upload JSON snapshot
//     final jsonName = _safe('$username - $contractId.json');
//     final jsonBytes = Uint8List.fromList(utf8.encode(jsonEncode(contractData)));
//     uploaded.add(
//       await _uploadBytes(
//         api: api,
//         parentId: contractFolderId,
//         bytes: jsonBytes,
//         filename: jsonName,
//         mimeType: 'application/json',
//         anyoneCanView: anyoneCanView,
//       ),
//     );

//     // 5) Upload image bytes (if any)
//     if (imageBytes != null && imageBytes.isNotEmpty) {
//       for (final e in imageBytes.entries) {
//         final label = _safe(e.key);
//         final filename = _safe('$username - $label.png');
//         uploaded.add(
//           await _uploadBytes(
//             api: api,
//             parentId: contractFolderId,
//             bytes: e.value,
//             filename: filename,
//             mimeType: lookupMimeType(filename) ?? 'application/octet-stream',
//             anyoneCanView: anyoneCanView,
//           ),
//         );
//       }
//     }

//     // 6) Upload local image files (if any)
//     if (imageFilePaths != null && imageFilePaths.isNotEmpty) {
//       for (final e in imageFilePaths.entries) {
//         final label = _safe(e.key);
//         final path = e.value;
//         final ext = path.split('.').last.toLowerCase();
//         final filename = _safe('$username - $label.$ext');
//         uploaded.add(
//           await _uploadFile(
//             api: api,
//             parentId: contractFolderId,
//             file: File(path),
//             filenameOverride: filename,
//             anyoneCanView: anyoneCanView,
//           ),
//         );
//       }
//     }

//     return DriveBundleResult(
//       userFolderId: userFolderId,
//       contractFolderId: contractFolderId,
//       files: uploaded,
//     );
//   }

//   // ---------- Internal helpers ----------

//   static Future<String> _ensureFolderInSharedDrive({
//     required drive.DriveApi api,
//     required String sharedDriveId,
//     required String name,
//     String? parentId,
//   }) async {
//     final escaped = _escape(name);
//     final parentFilter = parentId != null ? " and '$parentId' in parents" : "";
//     final q = "mimeType = 'application/vnd.google-apps.folder' "
//         "and name = '$escaped' and trashed = false$parentFilter";

//     final list = await api.files.list(
//       corpora: 'drive',
//       driveId: sharedDriveId,
//       includeItemsFromAllDrives: true,
//       supportsAllDrives: true,
//       q: q,
//       $fields: 'files(id,name)',
//       pageSize: 1,
//       spaces: 'drive',
//     );

//     if (list.files != null && list.files!.isNotEmpty) {
//       return list.files!.first.id!;
//     }

//     final meta = drive.File()
//       ..name = name
//       ..mimeType = 'application/vnd.google-apps.folder'
//       ..parents = parentId != null ? [parentId] : null;

//     final created = await api.files.create(
//       meta,
//       supportsAllDrives: true,
//       $fields: 'id',
//     );
//     return created.id!;
//   }

//   static Future<DriveUploadResult> _uploadBytes({
//     required drive.DriveApi api,
//     required String parentId,
//     required Uint8List bytes,
//     required String filename,
//     String? mimeType,
//     bool anyoneCanView = false,
//   }) async {
//     final mime = mimeType ?? lookupMimeType(filename) ?? 'application/octet-stream';

//     final meta = drive.File()
//       ..name = filename
//       ..mimeType = mime
//       ..parents = [parentId];

//     final media = drive.Media(Stream<List<int>>.value(bytes), bytes.length);

//     final created = await api.files.create(
//       meta,
//       uploadMedia: media,
//       supportsAllDrives: true,
//       $fields: 'id,name,webViewLink,parents',
//     );

//     if (anyoneCanView) {
//       await api.permissions.create(
//         drive.Permission()
//           ..type = 'anyone'
//           ..role = 'reader',
//         created.id!,
//         supportsAllDrives: true,
//       );
//     }

//     return DriveUploadResult(
//       id: created.id!,
//       name: created.name ?? filename,
//       webViewLink: created.webViewLink ?? '',
//       parentIds: (created.parents ?? const <String>[]),
//     );
//   }

//   static Future<DriveUploadResult> _uploadFile({
//     required drive.DriveApi api,
//     required String parentId,
//     required File file,
//     required String filenameOverride,
//     bool anyoneCanView = false,
//   }) async {
//     final mime = lookupMimeType(filenameOverride) ?? lookupMimeType(file.path) ?? 'application/octet-stream';

//     final meta = drive.File()
//       ..name = filenameOverride
//       ..mimeType = mime
//       ..parents = [parentId];

//     final media = drive.Media(file.openRead(), await file.length());

//     final created = await api.files.create(
//       meta,
//       uploadMedia: media,
//       supportsAllDrives: true,
//       $fields: 'id,name,webViewLink,parents',
//     );

//     if (anyoneCanView) {
//       await api.permissions.create(
//         drive.Permission()
//           ..type = 'anyone'
//           ..role = 'reader',
//         created.id!,
//         supportsAllDrives: true,
//       );
//     }

//     return DriveUploadResult(
//       id: created.id!,
//       name: created.name ?? filenameOverride,
//       webViewLink: created.webViewLink ?? '',
//       parentIds: (created.parents ?? const <String>[]),
//     );
//   }

//   static String _escape(String s) => s.replaceAll("'", r"\'");
//   static String _safe(String s) => s.replaceAll(RegExp(r'[\\/|:*?"<>]'), '-').trim();
// }
