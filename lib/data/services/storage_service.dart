import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/utils/app_logger.dart';

class StorageService {
  static const _cloudName = 'dvnmhataw';
  static const _uploadPreset = 'caliora_meals';

  Future<String> uploadMealImage(
      String userId, String fileName, File file) async {
    log.i('[Storage] Uploading meal image: $fileName');
    log.d('[Storage] User: $userId');
    log.d('[Storage] File path: ${file.path}');
    log.d('[Storage] File size: ${await file.length()} bytes');

    final dio = Dio();
    final formData = FormData.fromMap({
      'upload_preset': _uploadPreset,
      'folder': 'users/$userId/meals',
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    try {
      final stopwatch = Stopwatch()..start();
      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
        data: formData,
      );
      stopwatch.stop();

      final url = response.data['secure_url'] as String;
      log.i('[Storage] Upload complete in ${stopwatch.elapsedMilliseconds}ms');
      log.d('[Storage] URL: $url');
      return url;
    } catch (e, stackTrace) {
      log.e('[Storage] Upload failed: $e');
      log.e('[Storage] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> deleteMealImage(String userId, String imageUrl) async {
    log.d('[Storage] Delete requested for: $imageUrl (skipped - requires server-side)');
  }
}
