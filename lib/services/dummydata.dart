import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:edwardb/services/google_drive_services.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DriveDummyUploader {
  /// Generates a small text file and uploads it to Drive.
  static Future<void> uploadDummyTextFile() async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/dummy_${DateTime.now().millisecondsSinceEpoch}.txt');

    await file.writeAsString('Hello from Flutter Drive test!\nTime: ${DateTime.now()}');
    debugPrint('📄 Created dummy text file: ${file.path}');

    final link = await GoogleDriveService.uploadFile(file: file, folderId: "1eG_P8KSek5-_dv-gMqkPjae4t2TO9vbS");
    debugPrint('✅ Uploaded file → $link');
  }

  /// Generates random bytes (fake video) and uploads as MP4
  static Future<void> uploadDummyVideo() async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/sample_${Random().nextInt(9999)}.mp4');

    // generate ~200KB random data
    final bytes = Uint8List.fromList(List<int>.generate(200 * 1024, (_) => Random().nextInt(256)));
    await file.writeAsBytes(bytes);

    debugPrint('🎬 Created dummy MP4 file: ${file.path}');
    final link = await GoogleDriveService.uploadFile(file: file, folderId: "13Epy1TxTK3gRvKXLXc6IbNspYu05mRJ2" );
    debugPrint('✅ Uploaded video → $link');
  }

  /// Runs both uploads sequentially
  static Future<void> runAll() async {
    debugPrint('🚀 Starting Google Drive upload dummy test...');
    try {
      await uploadDummyTextFile();
      await uploadDummyVideo();
      debugPrint('🏁 Dummy upload test finished successfully.');
    } catch (e, st) {
      debugPrint('❌ Test failed: $e\n$st');
    }
  }
}
