import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/date_utils.dart';

class ScanLimitService {
  static int get dailyLimit => AppConfig.dailyScanLimit;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference _scanDoc(String userId, String date) =>
      _db.collection('users').doc(userId).collection('scan_usage').doc(date);

  Future<int> getTodayCount(String userId) async {
    final today = AppDateUtils.todayKey();
    final doc = await _scanDoc(userId, today).get();
    if (!doc.exists) return 0;
    final data = doc.data() as Map<String, dynamic>?;
    return data?['count'] ?? 0;
  }

  Future<bool> canScan(String userId) async {
    final count = await getTodayCount(userId);
    log.d('[ScanLimit] User $userId: $count/$dailyLimit scans today');
    return count < dailyLimit;
  }

  Future<void> incrementCount(String userId) async {
    final today = AppDateUtils.todayKey();
    await _scanDoc(userId, today).set({
      'count': FieldValue.increment(1),
      'lastUsed': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    log.d('[ScanLimit] Incremented scan count for $userId');
  }

  int get limit => dailyLimit;
}
