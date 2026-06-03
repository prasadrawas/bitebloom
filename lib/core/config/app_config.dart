import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized app configuration — reads from .env file.
/// Change values in .env without modifying code.
class AppConfig {
  // ── Cloudinary ──
  static String get cloudinaryCloudName =>
      dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? 'dvnmhataw';
  static String get cloudinaryUploadPreset =>
      dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? 'caliora_meals';

  // ── Gemini AI ──
  static String get geminiApiKey =>
      dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get geminiModel =>
      dotenv.env['GEMINI_MODEL'] ?? 'gemini-2.5-flash';
  static List<String> get geminiModels {
    final primary = geminiModel;
    final fallbacks = (dotenv.env['GEMINI_FALLBACK_MODELS'] ?? '')
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return [primary, ...fallbacks];
  }
  static double get geminiTemperature =>
      double.tryParse(dotenv.env['GEMINI_TEMPERATURE'] ?? '') ?? 0.3;
  static int get geminiMaxTokens =>
      int.tryParse(dotenv.env['GEMINI_MAX_TOKENS'] ?? '') ?? 4096;

  // ── Image Compression ──
  static int get imageMaxWidth =>
      int.tryParse(dotenv.env['IMAGE_MAX_WIDTH'] ?? '') ?? 800;
  static int get imageCompressionQuality =>
      int.tryParse(dotenv.env['IMAGE_COMPRESSION_QUALITY'] ?? '') ?? 70;
  static int get imagePickerMaxWidth =>
      int.tryParse(dotenv.env['IMAGE_PICKER_MAX_WIDTH'] ?? '') ?? 1024;
  static int get imagePickerQuality =>
      int.tryParse(dotenv.env['IMAGE_PICKER_QUALITY'] ?? '') ?? 85;

  // ── Daily Limits ──
  static int get dailyScanLimit =>
      int.tryParse(dotenv.env['DAILY_SCAN_LIMIT'] ?? '') ?? 10;

  // ── Default Nutrition Targets ──
  static int get defaultCalorieTarget =>
      int.tryParse(dotenv.env['DEFAULT_CALORIE_TARGET'] ?? '') ?? 2000;
  static int get defaultProteinTarget =>
      int.tryParse(dotenv.env['DEFAULT_PROTEIN_TARGET'] ?? '') ?? 150;
  static int get defaultCarbsTarget =>
      int.tryParse(dotenv.env['DEFAULT_CARBS_TARGET'] ?? '') ?? 200;
  static int get defaultFatTarget =>
      int.tryParse(dotenv.env['DEFAULT_FAT_TARGET'] ?? '') ?? 67;
  static int get defaultWaterTarget =>
      int.tryParse(dotenv.env['DEFAULT_WATER_TARGET'] ?? '') ?? 2500;
  static int get waterIncrement =>
      int.tryParse(dotenv.env['WATER_INCREMENT'] ?? '') ?? 250;

  // ── Goal Achievement ──
  static double get goalMetLower =>
      double.tryParse(dotenv.env['GOAL_MET_LOWER'] ?? '') ?? 0.9;
  static double get goalMetUpper =>
      double.tryParse(dotenv.env['GOAL_MET_UPPER'] ?? '') ?? 1.1;
}
