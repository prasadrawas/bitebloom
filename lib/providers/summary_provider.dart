import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/daily_summary.dart';
import '../core/utils/date_utils.dart';
import 'auth_provider.dart';
import 'meals_provider.dart';
import 'profile_provider.dart';

final dailySummaryProvider = StreamProvider<DailySummary?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  final today = AppDateUtils.todayKey();
  return ref.watch(firestoreServiceProvider).streamDailySummary(user.uid, today);
});

final selectedDateSummaryProvider = StreamProvider<DailySummary?>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(null);
  final selectedDate = ref.watch(selectedDateProvider);
  final dateKey = AppDateUtils.formatDate(selectedDate);
  return ref.watch(firestoreServiceProvider).streamDailySummary(user.uid, dateKey);
});
