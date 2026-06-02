import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/daily_summary.dart';
import '../core/utils/date_utils.dart';
import 'auth_provider.dart';
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
  // For diary screen we could use a separate date provider if needed
  final today = AppDateUtils.todayKey();
  return ref.watch(firestoreServiceProvider).streamDailySummary(user.uid, today);
});
