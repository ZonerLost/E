import 'dart:io';
import 'dart:typed_data';

import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:edwardb/data/term_condition_text.dart';

class PdfArchiveService {
  PdfArchiveService._();
  static final PdfArchiveService instance = PdfArchiveService._();

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
          'PdfArchiveService: Falling back to app documents (cannot write to $docsPath)',
        );
      } catch (e, st) {
        debugPrint('PdfArchiveService: public Documents unavailable → $e\n$st');
      }
    }

    final docs = await getApplicationDocumentsDirectory();
    return _ensureDir(docs.path);
  }

  Future<Directory> _ensureDir(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
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

  Future<File> saveContractPdf({
    required String topFolderName,
    required String username,
    required String contractId,
    required Map<String, dynamic> contractData,
    Map<String, String> imageFilePaths = const {},
    Map<String, Uint8List> imageBytes = const {},
    Map<String, bool> agreementStatuses = const {},
  }) async {
    final base = await _baseDir();
    final bundleRoot = p.join(
      base.path,
      _safeName(topFolderName),
      _safeName(username),
      _safeName(contractId),
    );

    final bundleDir = await _ensureDir(bundleRoot);
    final images = await _gatherImages(imageFilePaths, imageBytes);
    final agreementEntries = agreementStatuses.entries.toList();
    final termTexts = termConditionTexts;

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          final fields = contractData.entries
              .where((entry) => entry.value != null)
              .map((entry) => [
                    _labelForField(entry.key),
                    _stringify(entry.value),
                  ])
              .toList();

          final widgets = <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text(
                'Rental Contract',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Contract ID: ${contractData['contractId'] ?? contractId}',
              style: const pw.TextStyle(fontSize: 12),
            ),
            pw.SizedBox(height: 12),
            if (fields.isNotEmpty)
              pw.Table.fromTextArray(
                headers: const ['Field', 'Value'],
                data: fields,
                cellAlignment: pw.Alignment.centerLeft,
                headerStyle:  pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                cellStyle: const pw.TextStyle(fontSize: 11),
                // cellAlignmentVertical: pw.Alignment.center,
              ),
            if (agreementEntries.isNotEmpty) pw.SizedBox(height: 16),
            if (agreementEntries.isNotEmpty)
              pw.Text(
                'Agreements',
                style:  pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.black,
                ),
              ),
            if (agreementEntries.isNotEmpty)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: agreementEntries
                    .map(
                      (entry) => pw.Bullet(
                        text:
                            '${entry.key} — ${entry.value ? 'Accepted' : 'Pending'}',
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    )
                    .toList(),
              ),
            if (termTexts.isNotEmpty) pw.SizedBox(height: 24),
            if (termTexts.isNotEmpty)
              pw.Header(
                level: 1,
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            if (termTexts.isNotEmpty) ..._buildTermParagraphs(termTexts),
            if (images.isNotEmpty) pw.SizedBox(height: 16),
            ...images.map(
              (image) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    image.label,
                    style:  pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(
                        color: PdfColors.grey300,
                        width: 0.5,
                      ),
                    ),
                    child: pw.Image(
                      pw.MemoryImage(image.bytes),
                      width: double.infinity,
                      height: 150,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                  pw.SizedBox(height: 12),
                ],
              ),
            ),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Generated at ${DateTime.now().toIso8601String()}',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey),
              ),
            ),
          ];

          return widgets;
        },
      ),
    );

    final fileName = 'contract-${_safeName(contractId)}-${_ts()}.pdf';
    final file = File(p.join(bundleDir.path, fileName));
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  Future<List<_PdfImage>> _gatherImages(
    Map<String, String> paths,
    Map<String, Uint8List> bytes,
  ) async {
    final list = <_PdfImage>[];
    for (final entry in paths.entries) {
      final data = await _bytesFromPath(entry.value);
      if (data != null) {
        list.add(_PdfImage(_labelForImage(entry.key), data));
      }
    }

    for (final entry in bytes.entries) {
      final data = entry.value;
      if (data.isNotEmpty) {
        list.add(_PdfImage(_labelForImage(entry.key), data));
      }
    }
    return list;
  }

  Future<Uint8List?> _bytesFromPath(String path) async {
    final file = File(path);
    if (!await file.exists()) return null;
    return await file.readAsBytes();
  }

  String _labelForField(String key) {
    const overrides = {
      'contractId': 'Contract ID',
      'contractName': 'Contract Name',
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
      'date': 'Date',
    };
    if (overrides.containsKey(key)) {
      return overrides[key]!;
    }
    final spaced = key
        .replaceAll('_', ' ')
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}');
    return spaced.trim().split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String _labelForImage(String key) {
    const overrides = {
      'driverPhoto': 'Driver Photo',
      'customerLicensePhoto': 'Customer License Photo',
      'signature': 'Signature',
      'signatureCard': 'Card Signature',
      'signatureInitial': 'Initials Signature',
    };
    return overrides[key] ?? _labelForField(key);
  }

  String _stringify(dynamic value) {
    if (value == null) return '';
    if (value is DateTime) return value.toIso8601String();
    if (value is Uint8List) return 'Image (${value.length} bytes)';
    return value.toString();
  }

  List<pw.Widget> _buildTermParagraphs(List<String> texts) {
    final widgets = <pw.Widget>[];
    for (final text in texts) {
      if (_isAgreementCheckbox(text)) {
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Bullet(
              text: text,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        );
      } else {
        final isHeading = _isTermHeading(text);
        widgets.add(
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 4),
            child: pw.Text(
              text,
              style: pw.TextStyle(
                fontSize: isHeading ? 12 : 11,
                fontWeight: isHeading ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: text == 'IMPORTANT!!!' ? PdfColors.red : PdfColors.black,
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  bool _isTermHeading(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;
    if (RegExp(r'^(\d+\.)').hasMatch(trimmed)) return true;
    const headings = {
      'Start New Rental Contract',
      'SIDE BY SIDE, ATV, MOTORCYCLE, SCOOTER',
      'Xplore SXM NV, SXM RALLY TOURS Agreement Terms and Conditions and Release of Liability',
      'Enter signature using stylus or finger',
      'Enter Initials using Stylus or Finger',
      'Card details',
      'Before continuing please confirm you understand the agreement',
      'IMPORTANT!!!',
    };
    if (headings.contains(trimmed)) return true;
    if (trimmed.startsWith('Enter ')) return true;
    return false;
  }

  bool _isAgreementCheckbox(String text) {
    final trimmed = text.trim();
    return trimmed.startsWith('I agree ') ||
        trimmed.startsWith('I understand ') ||
        trimmed.startsWith('I confirm ');
  }
}

class _PdfImage {
  final String label;
  final Uint8List bytes;

  _PdfImage(this.label, this.bytes);
}
