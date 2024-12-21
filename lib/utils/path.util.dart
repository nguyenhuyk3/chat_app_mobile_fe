import 'dart:io';

import 'package:chat_app_mobile_fe/utils/log.utils.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class PathUtil {
  static final logger = Logger(printer: CustomPrinter());

  static Future<String> createAudioPath() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final recordingDir = Directory('${appDocDir.path}/recordings');

    if (!await recordingDir.exists()) {
      await recordingDir.create(recursive: true);
    }

    return '${recordingDir.path}/audio_$timestamp.aac';
  }

  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<String?> downloadAudioFile(String sourcePath) async {
    try {
      const String audioDir = 'C:/ChatAppAudio'; // hoặc 'C:\\ChatAppAudio'
      final Directory directory = Directory(audioDir);
      
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final fileName = sourcePath.split('/').last;
      final destinationPath = '$audioDir/$fileName';
      final File sourceFile = File(sourcePath);

      await sourceFile.copy(destinationPath);

      logger.w("==================================");
      logger.i("downloadAudioFile");
      logger.i("Đường dẫn nguồn: $sourcePath");
      logger.i("Tên file: $fileName");
      logger.i("Đã lưu tại: $destinationPath");
      logger.w("==================================");

      return destinationPath;
    } catch (e) {
      logger.e("Lỗi khi tải file audio: $e");
      return null;
    }
  }
}
