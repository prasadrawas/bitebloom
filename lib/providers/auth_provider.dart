import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config/app_config.dart';
import '../data/services/auth_service.dart';
import '../data/services/gemini_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final geminiServiceProvider = Provider<GeminiService>(
    (ref) => GeminiService(apiKey: AppConfig.geminiApiKey));

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});
