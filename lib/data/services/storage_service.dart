import 'dart:io';
import 'package:dio/dio.dart';

class StorageService {
  static const _cloudName = 'dvnmhataw';
  static const _uploadPreset = 'caliora_meals';

  Future<String> uploadMealImage(
      String userId, String fileName, File file) async {
    final dio = Dio();
    final formData = FormData.fromMap({
      'upload_preset': _uploadPreset,
      'folder': 'users/$userId/meals',
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await dio.post(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
      data: formData,
    );

    return response.data['secure_url'] as String;
  }

  Future<void> deleteMealImage(String userId, String imageUrl) async {
    // Cloudinary deletion requires signed API calls (server-side).
  }
}
