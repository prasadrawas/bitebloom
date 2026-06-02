import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/app_logger.dart';
import '../models/meal_entry.dart';

class GeminiService {
  final String _apiKey;
  final Dio _dio = Dio();

  GeminiService({required String apiKey}) : _apiKey = apiKey;

  Future<MealEntry?> analyzeFood(File imageFile, {String notes = ''}) async {
    log.i('[Gemini] Starting food analysis');
    log.d('[Gemini] Image path: ${imageFile.path}');
    log.d('[Gemini] Image size: ${await imageFile.length()} bytes');
    log.d('[Gemini] User notes: ${notes.isEmpty ? "(none)" : notes}');

    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);
    log.d('[Gemini] Base64 image length: ${base64Image.length}');

    var promptText = AppStrings.geminiPrompt;
    if (notes.isNotEmpty) {
      promptText += '\n\nUser notes about this meal: $notes';
    }

    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$_apiKey';

    log.i('[Gemini] Sending request to Gemini 2.5 Flash');
    log.d('[Gemini] API URL: ${url.replaceAll(_apiKey, '***')}');

    try {
      final stopwatch = Stopwatch()..start();
      final response = await _dio.post(
        url,
        data: {
          'contents': [
            {
              'parts': [
                {'text': promptText},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image,
                  }
                },
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.3,
            'maxOutputTokens': 4096,
          },
        },
      );
      stopwatch.stop();

      log.i('[Gemini] Response received in ${stopwatch.elapsedMilliseconds}ms');
      log.d('[Gemini] Status code: ${response.statusCode}');
      log.d('[Gemini] Response data keys: ${response.data?.keys}');

      final text = response.data['candidates']?[0]?['content']?['parts']?[0]
          ?['text'] as String?;

      if (text == null) {
        log.w('[Gemini] Response text is null');
        log.d('[Gemini] Full response: ${response.data}');
        return null;
      }

      log.d('[Gemini] Raw response text:\n$text');

      // Clean up response - remove markdown code blocks if present
      String cleanJson = text.trim();
      if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.replaceAll(RegExp(r'^```\w*\n?'), '');
        cleanJson = cleanJson.replaceAll(RegExp(r'\n?```$'), '');
        log.d('[Gemini] Cleaned markdown code blocks');
      }

      final decoded = jsonDecode(cleanJson);
      if (decoded is! Map<String, dynamic>) {
        log.e('[Gemini] Response is not a JSON object: ${decoded.runtimeType}');
        return null;
      }
      final json = decoded;
      log.i('[Gemini] Parsed JSON successfully');
      log.d('[Gemini] Meal name: ${json['meal_name']}');
      log.d('[Gemini] Calories: ${json['calories']}');
      log.d('[Gemini] Items detected: ${json['items_detected']}');
      log.d('[Gemini] Confidence: ${json['confidence']}');

      final meal = MealEntry(
        id: '',
        mealName: json['meal_name'] ?? 'Unknown Food',
        calories: (json['calories'] ?? 0).toInt(),
        protein: (json['protein_g'] ?? 0).toDouble(),
        carbs: (json['carbs_g'] ?? 0).toDouble(),
        fat: (json['fat_g'] ?? 0).toDouble(),
        fiber: (json['fiber_g'] ?? 0).toDouble(),
        sugar: (json['sugar_g'] ?? 0).toDouble(),
        saturatedFat: (json['saturated_fat_g'] ?? 0).toDouble(),
        sodium: (json['sodium_mg'] ?? 0).toDouble(),
        potassium: (json['potassium_mg'] ?? 0).toDouble(),
        calcium: (json['calcium_mg'] ?? 0).toDouble(),
        iron: (json['iron_mg'] ?? 0).toDouble(),
        magnesium: (json['magnesium_mg'] ?? 0).toDouble(),
        vitaminA: (json['vitamin_a_mcg'] ?? 0).toDouble(),
        vitaminC: (json['vitamin_c_mg'] ?? 0).toDouble(),
        vitaminD: (json['vitamin_d_mcg'] ?? 0).toDouble(),
        vitaminB12: (json['vitamin_b12_mcg'] ?? 0).toDouble(),
        servingSize: json['serving_size'] ?? '1 serving',
        mealType: MealEntry.mealTypeFromTime(DateTime.now()),
        itemsDetected: List<String>.from(json['items_detected'] ?? []),
      );

      log.i('[Gemini] MealEntry created: ${meal.mealName} (${meal.calories} kcal)');
      return meal;
    } on DioException catch (e) {
      log.e('[Gemini] DioException: ${e.type}');
      log.e('[Gemini] Status code: ${e.response?.statusCode}');
      log.e('[Gemini] Response body: ${e.response?.data}');
      log.e('[Gemini] Message: ${e.message}');
      final errorMsg = e.response?.data?['error']?['message'] ??
          e.message ??
          'Unknown error';
      throw GeminiAnalysisException('Failed to analyze food image: $errorMsg');
    } catch (e, stackTrace) {
      log.e('[Gemini] Unexpected error: $e');
      log.e('[Gemini] Stack trace: $stackTrace');
      throw GeminiAnalysisException('Failed to analyze food image: $e');
    }
  }
}

class GeminiAnalysisException implements Exception {
  final String message;
  GeminiAnalysisException(this.message);

  @override
  String toString() => message;
}
