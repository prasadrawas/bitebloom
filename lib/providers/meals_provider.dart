import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/meal_entry.dart';
import 'auth_provider.dart';
import 'profile_provider.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final mealsForDateProvider = StreamProvider<List<MealEntry>>((ref) {
  final user = ref.watch(currentUserProvider);
  final date = ref.watch(selectedDateProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).streamMealsForDate(user.uid, date);
});

final todayMealsProvider = StreamProvider<List<MealEntry>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).streamTodayMeals(user.uid);
});
