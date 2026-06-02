import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/user_profile.dart';
import '../data/services/firestore_service.dart';
import 'auth_provider.dart';

final firestoreServiceProvider =
    Provider<FirestoreService>((ref) => FirestoreService());

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  return ref.watch(firestoreServiceProvider).streamProfile(user.uid);
});

final hasProfileProvider = FutureProvider<bool>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return false;
  return ref.watch(firestoreServiceProvider).hasProfile(user.uid);
});
