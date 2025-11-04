import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';

/// LocalArchiveService
/// - Saves bytes/files as image/video/text/json
/// - Builds a bundle folde
/// - Returns absolute file paths for later use (UI, upload, share)
class LocalArchiveService {
  LocalArchiveService._();
  static final LocalArchiveService instance = LocalArchiveService._();

  /// Base directory used for all saves (public & visible in Files if possible).
  ///
  /// ANDROID → /storage/emulated/0/Documents
  ///   - Attempts to use the shared Documents folder; if writing fails (e.g.
  ///     permission denied), falls back to app documents storage.
  ///
  /// iOS → App's Documents (visible in Files with Info.plist flags).
  Future<Directory> _baseDir() async {
    if (Platform.isAndroid) {
      try {
        final docsPath = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOCUMENTS,
        );
        final publicDir = await _ensureDir(docsPath);
        final canWrite = await _canWriteToDirectory(publicDir);
        if (canWrite) {
          return publicDir;
        }
        debugPrint(
          'LocalArchiveService: Falling back to app documents (cannot write to $docsPath)',
        );
      } catch (e, st) {
        debugPrint('LocalArchiveService: public Documents unavailable → $e\n$st');
      }
    }

    final docs = await getApplicationDocumentsDirectory();
    return _ensureDir(docs.path);
  }

  Future<Directory> _ensureDir(String dirPath) async {
    final d = Directory(dirPath);
    if (!await d.exists()) {
      await d.create(recursive: true);
    }
    return d;
  }

  String _ts() => DateTime.now().millisecondsSinceEpoch.toString();

  String _safeName(String name) =>
      name.replaceAll(RegExp(r'[^\w\-. ]+'), '_').trim();

  Future<bool> _canWriteToDirectory(Directory dir) async {
    try {
      final probe = File(
        p.join(
          dir.path,
          '.perm_probe_${DateTime.now().microsecondsSinceEpoch}',
        ),
      );
      await probe.create(recursive: true);
      await probe.writeAsBytes(const <int>[], flush: true);
      await probe.delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Low-level, generic saves
  // ---------------------------------------------------------------------------

  /// Save raw bytes to a file at a relative folder (under _baseDir()).
  Future<File> saveBytes({
    required Uint8List bytes,
    required String relativeFolder,
    required String fileName,
  }) async {
    final base = await _baseDir();
    final dir = await _ensureDir(p.join(base.path, relativeFolder));
    final file = File(p.join(dir.path, _safeName(fileName)));
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// Save a UTF-8 text file.
  Future<File> saveText({
    required String content,
    required String relativeFolder,
    required String fileName, // e.g., "notes.txt"
    bool append = false,
  }) async {
    final base = await _baseDir();
    final dir = await _ensureDir(p.join(base.path, relativeFolder));
    final file = File(p.join(dir.path, _safeName(fileName)));
    final sink = file.openWrite(
      mode: append ? FileMode.append : FileMode.write,
      encoding: utf8,
    );
    sink.write(content);
    await sink.flush();
    await sink.close();
    return file;
  }

  /// Save a JSON map as a pretty JSON file.
  Future<File> saveJson({
    required Map<String, dynamic> jsonMap,
    required String relativeFolder,
    String fileName = 'data.json',
  }) async {
    final pretty = const JsonEncoder.withIndent('  ').convert(jsonMap);
    return saveText(
      content: pretty,
      relativeFolder: relativeFolder,
      fileName: fileName.endsWith('.json') ? fileName : '$fileName.json',
    );
  }

  /// Copy a file from an existing path into our archive.
  Future<File> copyFromPath({
    required String sourcePath,
    required String relativeFolder,
    String? overrideFileName,
  }) async {
    final src = File(sourcePath);
    if (!await src.exists()) {
      throw Exception('Source file not found: $sourcePath');
    }
    final base = await _baseDir();
    final dir = await _ensureDir(p.join(base.path, relativeFolder));
    final targetName = _safeName(
      overrideFileName ??
          '${p.basenameWithoutExtension(sourcePath)}-${_ts()}${p.extension(sourcePath)}',
    );
    final dest = File(p.join(dir.path, targetName));
    return src.copy(dest.path);
  }

  // Convenience wrappers
  Future<File> saveImageBytes({
    required Uint8List bytes,
    required String relativeFolder,
    String fileName = '',
    String formatExt = '.png', // .png/.jpg
  }) {
    final name = (fileName.isEmpty ? 'image-$_ts()' : fileName);
    return saveBytes(
      bytes: bytes,
      relativeFolder: relativeFolder,
      fileName: name.endsWith(formatExt) ? name : '$name$formatExt',
    );
  }

  Future<File> saveVideoFromPath({
    required String sourcePath,
    required String relativeFolder,
    String fileName = '',
  }) {
    final normalizedExt = _normalizeVideoExtension(p.extension(sourcePath));
    final name = fileName.isEmpty
        ? 'video-${_ts()}$normalizedExt'
        : _withNormalizedExtension(fileName, normalizedExt);
    return copyFromPath(
      sourcePath: sourcePath,
      relativeFolder: relativeFolder,
      overrideFileName: name,
    );
  }

  // ---------------------------------------------------------------------------
  // Bundle builders
  // ---------------------------------------------------------------------------

  /// Returns the bundle folder path:
  /// <base>/<topFolderName>/<username>/<contractId>
  Future<String> bundleFolderPath({
    required String topFolderName,
    required String username,
    required String contractId,
  }) async {
    final base = await _baseDir();
    return p.join(
      base.path,
      _safeName(topFolderName),
      _safeName(username),
      _safeName(contractId),
    );
  }

  /// Save a "contract bundle" locally.
  ///
  /// - imageFilePaths: key -> local file path to COPY in
  /// - imageBytes:     key -> bytes to save as PNG in /images
  /// - alsoWriteTxt:   write a human-readable TXT summary (Label : value)
  ///
  /// Returns: map of keys -> absolute paths (includes 'contractJson' and
  /// optionally 'contractTxt' entries).
  Future<Map<String, String>> saveContractBundle({
    required String topFolderName,
    required String username,
    required String contractId,
    required Map<String, dynamic> contractData,
    Map<String, String> imageFilePaths = const {},
    Map<String, Uint8List> imageBytes = const {},
    String contractJsonName = 'contract.json',
    String imagesFolderName = 'images',
    bool alsoWriteTxt = true,
    String contractTxtName = 'contract.txt',
    List<String> txtFieldOrder = const [
      'contractId',
      'contractName',
      'date',
      'firstName',
      'lastName',
      'email',
      'phoneNumber',
      'licenseNumber',
      'cardNumber',
      'cardExpiryDate',
      'cvc',
      'status',
      'createdAt',
      'updatedAt',
    ],
    Map<String, String> txtLabels = const {
      'contractId': 'Contract ID',
      'contractName': 'Contract Name',
      'date': 'Date',
      'firstName': 'First Name',
      'lastName': 'Last Name',
      'email': 'Email',
      'phoneNumber': 'Phone Number',
      'licenseNumber': 'License Number',
      'cardNumber': 'Card Number',
      'cardExpiryDate': 'Card Expiry',
      'cvc': 'CVC',
      'status': 'Status',
      'createdAt': 'Created At',
      'updatedAt': 'Updated At',
    },
  }) async {
    final outputs = <String, String>{};
    final bundleRoot = await bundleFolderPath(
      topFolderName: topFolderName,
      username: username,
      contractId: contractId,
    );

    // Ensure root + images folder
    final base = await _baseDir();
    final root = await _ensureDir(bundleRoot);
    final imagesDir = await _ensureDir(p.join(root.path, imagesFolderName));
    final relRoot = p.relative(root.path, from: base.path);
    final relImages = p.relative(imagesDir.path, from: base.path);

    // 1) JSON snapshot of the contract (kept for programmatic use)
    final jsonFile = await saveJson(
      jsonMap: contractData,
      relativeFolder: relRoot,
      fileName: contractJsonName,
    );
    outputs['contractJson'] = jsonFile.path;

    // 2) Copy image/file paths in
    for (final entry in imageFilePaths.entries) {
      final key = entry.key; // e.g., "driverPhoto"
      final src = entry.value;
      final dest = await copyFromPath(
        sourcePath: src,
        relativeFolder: relImages,
        overrideFileName:
            '${_safeName(key)}-${_ts()}${p.extension(src).isEmpty ? '' : p.extension(src)}',
      );
      outputs[key] = dest.path;
    }

    // 3) Save raw bytes (e.g., signatures) as PNG
    for (final entry in imageBytes.entries) {
      final key = entry.key; // e.g., "signature"
      final f = await saveImageBytes(
        bytes: entry.value,
        relativeFolder: relImages,
        fileName: '${_safeName(key)}-${_ts()}',
        formatExt: '.png',
      );
      outputs[key] = f.path;
    }

    // 4) Human-readable TXT summary (Label : value), if requested
    if (alsoWriteTxt) {
      final txt = await saveKeyValueTxt(
        data: contractData,
        relativeFolder: relRoot,
        fileName: contractTxtName,
        fieldOrder: txtFieldOrder,
        labels: txtLabels,
        maskSensitive: true,
      );
      outputs['contractTxt'] = txt.path;
    }

    return outputs;
  }

  /// Save an "inspection bundle": video + signature + JSON snapshot (+ TXT).
  Future<Map<String, String>> saveInspectionBundle({
    required String topFolderName,
    required String username,
    required String contractId,
    required String videoFilePath,
    required Uint8List signatureBytes,
    Map<String, dynamic> inspectionData = const {},
    String inspectionJsonName = 'inspection.json',
    bool alsoWriteTxt = true,
  }) async {
    final outputs = <String, String>{};
    final base = await _baseDir();
    final bundleRoot = await bundleFolderPath(
      topFolderName: topFolderName,
      username: username,
      contractId: contractId,
    );

    final root = await _ensureDir(bundleRoot);
    final insDir = await _ensureDir(p.join(root.path, 'inspection'));

    final relIns = p.relative(insDir.path, from: base.path);

    // video
    final video = await saveVideoFromPath(
      sourcePath: videoFilePath,
      relativeFolder: relIns,
      fileName:
          'video-${_ts()}${p.extension(videoFilePath).isEmpty ? '.mp4' : p.extension(videoFilePath)}',
    );
    outputs['inspectionVideo'] = video.path;

    // signature image
    final sig = await saveImageBytes(
      bytes: signatureBytes,
      relativeFolder: relIns,
      fileName: 'signature-${_ts()}',
      formatExt: '.png',
    );
    outputs['inspectionSignature'] = sig.path;

    // json snapshot
    final snapshotJson = await saveJson(
      jsonMap: {
        'type': 'inspection',
        'contractId': contractId,
        ...inspectionData,
        'savedAtLocalTs': DateTime.now().toIso8601String(),
      },
      relativeFolder: relIns,
      fileName: inspectionJsonName,
    );
    outputs['inspectionJson'] = snapshotJson.path;

    // optional TXT summary
    if (alsoWriteTxt) {
      final baseRel = p.relative(root.path, from: base.path);
      final txt = await saveKeyValueTxt(
        data: {
          'type': 'Inspection',
          'contractId': contractId,
          'video': p.basename(video.path),
          'signature': p.basename(sig.path),
          if (inspectionData.isNotEmpty) ...inspectionData,
          'savedAtLocalTs': DateTime.now().toIso8601String(),
        },
        relativeFolder: baseRel,
        fileName: 'inspection.txt',
        fieldOrder: const [
          'type',
          'contractId',
          'video',
          'signature',
          'savedAtLocalTs',
        ],
        labels: const {
          'type': 'Type',
          'contractId': 'Contract ID',
          'video': 'Video File',
          'signature': 'Signature File',
          'savedAtLocalTs': 'Saved At',
        },
        maskSensitive: false,
      );
      outputs['inspectionTxt'] = txt.path;
    }

    return outputs;
  }

  // ---------------------------------------------------------------------------
  // TXT helpers
  // ---------------------------------------------------------------------------

  String _maskSensitiveValue(String key, String value, bool mask) {
    if (!mask) return value;
    final k = key.toLowerCase();
    if (k.contains('cardnumber') || k == 'cardnumber' || k == 'card_number') {
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 4) return '****';
      final last4 = digits.substring(digits.length - 4);
      return '**** **** **** $last4';
    }
    if (k == 'cvc' || k.contains('cvv') || k.contains('cvc')) {
      return '***';
    }
    return value;
  }

  String _stringifyValue(dynamic raw) {
    if (raw is DateTime) {
      return raw.toIso8601String();
    }
    if (raw is Uint8List) {
      return 'bytes(${raw.length})';
    }
    return raw.toString();
  }

  String _normalizeVideoExtension(String ext) {
    const fallback = '.mp4';
    if (ext.isEmpty) return fallback;
    final lower = ext.toLowerCase();
    if (_isTempExtension(lower)) {
      return fallback;
    }
    return lower;
  }

  String _withNormalizedExtension(String fileName, String normalizedExt) {
    final ext = p.extension(fileName);
    if (ext.isEmpty) {
      return '$fileName$normalizedExt';
    }
    final lower = ext.toLowerCase();
    if (_isTempExtension(lower)) {
      return fileName.substring(0, fileName.length - ext.length) + normalizedExt;
    }
    return fileName;
  }

  bool _isTempExtension(String ext) => ext == '.tmp' || ext == '.temp';

  /// Save plain-text lines (values only, no key/value pairs).
  Future<File> saveKeyValueTxt({
    required Map<String, dynamic> data,
    required String relativeFolder,
    String fileName = 'contract.txt',
    List<String> fieldOrder = const [],
    Map<String, String> labels = const {},
    bool maskSensitive = true,
    bool includeEmpty = false,
  }) async {
    final baseOrder = <String>[...fieldOrder];
    for (final key in labels.keys) {
      if (!baseOrder.contains(key)) {
        baseOrder.add(key);
      }
    }

    final ordered = <String>[
      ...baseOrder,
      ...data.keys.where((k) => !baseOrder.contains(k)),
    ];

    // build rows
    final rows = <String>[];
    for (final key in ordered) {
      final raw = data[key];
      if (raw == null) {
        if (includeEmpty) rows.add('');
        continue;
      }
      String val = _stringifyValue(raw);
      if (val.trim().isEmpty && !includeEmpty) continue;

      val = _maskSensitiveValue(key, val, maskSensitive);
      rows.add(val);
    }

    final buf = StringBuffer();
    for (final value in rows) {
      buf.writeln(value);
    }

    return saveText(
      content: buf.toString(),
      relativeFolder: relativeFolder,
      fileName: fileName.endsWith('.txt') ? fileName : '$fileName.txt',
    );
  }

  /// Convenience to save a contract TXT report inside the bundle folder.
  Future<File> saveContractTxtReport({
    required String topFolderName,
    required String username,
    required String contractId,
    required Map<String, dynamic> contractData,
    String fileName = 'contract.txt',
    bool maskSensitive = true,
  }) async {
    final base = await _baseDir();
    final bundleRoot = await bundleFolderPath(
      topFolderName: topFolderName,
      username: username,
      contractId: contractId,
    );
    final rel = p.relative(bundleRoot, from: base.path);

    const order = [
      'contractId',
      'contractName',
      'date',
      'firstName',
      'lastName',
      'email',
      'phoneNumber',
      'licenseNumber',
      'cardNumber',
      'cardExpiryDate',
      'cvc',
      'status',
      'createdAt',
      'updatedAt',
    ];

    final labels = <String, String>{
      'contractId': 'Contract ID',
      'contractName': 'Contract Name',
      'date': 'Date',
      'firstName': 'First Name',
      'lastName': 'Last Name',
      'email': 'Email',
      'phoneNumber': 'Phone Number',
      'licenseNumber': 'License Number',
      'cardNumber': 'Card Number',
      'cardExpiryDate': 'Card Expiry',
      'cvc': 'CVC',
      'status': 'Status',
      'createdAt': 'Created At',
      'updatedAt': 'Updated At',
    };

    return saveKeyValueTxt(
      data: contractData,
      relativeFolder: rel,
      fileName: fileName,
      fieldOrder: order,
      labels: labels,
      maskSensitive: maskSensitive,
    );
  }

  // ---------------------------------------------------------------------------
  // Utilities
  // ---------------------------------------------------------------------------

  /// Returns the absolute base path (Documents on Android/iOS).
  Future<String> archiveRootPath() async => (await _baseDir()).path;

  /// Delete a file or directory (recursive for directories).
  Future<void> deleteAtPath(String absolutePath) async {
    final entity = FileSystemEntity.typeSync(absolutePath);
    if (entity == FileSystemEntityType.notFound) return;
    final stat = await FileStat.stat(absolutePath);
    if (stat.type == FileSystemEntityType.directory) {
      final dir = Directory(absolutePath);
      if (await dir.exists()) await dir.delete(recursive: true);
    } else {
      final file = File(absolutePath);
      if (await file.exists()) await file.delete();
    }
  }

  /// List contents of a relative folder under archive root.
  Future<List<FileSystemEntity>> listRelative(String relativeFolder) async {
    final base = await _baseDir();
    final dir = Directory(p.join(base.path, relativeFolder));
    if (!await dir.exists()) return [];
    return dir.list(recursive: false).toList();
  }
}
