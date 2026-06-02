import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/daily_summary.dart';
import '../data/models/weight_log.dart';
import '../core/utils/date_utils.dart';
import 'auth_provider.dart';
import 'profile_provider.dart';

final isMonthlyViewProvider = StateProvider<bool>((ref) => false);

final weeklyProgressProvider = FutureProvider<List<DailySummary>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final days = AppDateUtils.getLast7Days();
  return ref.watch(firestoreServiceProvider).getSummariesForRange(user.uid, days);
});

final monthlyProgressProvider = FutureProvider<List<DailySummary>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final days = AppDateUtils.getLast30Days();
  return ref.watch(firestoreServiceProvider).getSummariesForRange(user.uid, days);
});

final weightLogsProvider = StreamProvider<List<WeightLog>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(firestoreServiceProvider).streamWeightLogs(user.uid);
});
