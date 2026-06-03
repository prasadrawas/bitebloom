import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/services/notification_service.dart';

final reminderProvider =
    StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  return ReminderNotifier();
});

class ReminderState {
  final bool enabled;
  final int breakfastHour;
  final int breakfastMinute;
  final int lunchHour;
  final int lunchMinute;
  final int dinnerHour;
  final int dinnerMinute;

  const ReminderState({
    this.enabled = false,
    this.breakfastHour = 10,
    this.breakfastMinute = 0,
    this.lunchHour = 14,
    this.lunchMinute = 0,
    this.dinnerHour = 20,
    this.dinnerMinute = 0,
  });

  ReminderState copyWith({
    bool? enabled,
    int? breakfastHour,
    int? breakfastMinute,
    int? lunchHour,
    int? lunchMinute,
    int? dinnerHour,
    int? dinnerMinute,
  }) {
    return ReminderState(
      enabled: enabled ?? this.enabled,
      breakfastHour: breakfastHour ?? this.breakfastHour,
      breakfastMinute: breakfastMinute ?? this.breakfastMinute,
      lunchHour: lunchHour ?? this.lunchHour,
      lunchMinute: lunchMinute ?? this.lunchMinute,
      dinnerHour: dinnerHour ?? this.dinnerHour,
      dinnerMinute: dinnerMinute ?? this.dinnerMinute,
    );
  }
}

class ReminderNotifier extends StateNotifier<ReminderState> {
  static const _keyEnabled = 'reminders_enabled';
  static const _keyBreakfastH = 'reminder_breakfast_h';
  static const _keyBreakfastM = 'reminder_breakfast_m';
  static const _keyLunchH = 'reminder_lunch_h';
  static const _keyLunchM = 'reminder_lunch_m';
  static const _keyDinnerH = 'reminder_dinner_h';
  static const _keyDinnerM = 'reminder_dinner_m';

  final NotificationService _notifService = NotificationService();

  ReminderNotifier() : super(const ReminderState()) {
    _load();
  }

  Future<void> _load() async {
    await _notifService.init();
    final prefs = await SharedPreferences.getInstance();
    state = ReminderState(
      enabled: prefs.getBool(_keyEnabled) ?? false,
      breakfastHour: prefs.getInt(_keyBreakfastH) ?? 10,
      breakfastMinute: prefs.getInt(_keyBreakfastM) ?? 0,
      lunchHour: prefs.getInt(_keyLunchH) ?? 14,
      lunchMinute: prefs.getInt(_keyLunchM) ?? 0,
      dinnerHour: prefs.getInt(_keyDinnerH) ?? 20,
      dinnerMinute: prefs.getInt(_keyDinnerM) ?? 0,
    );
  }

  Future<void> toggle() async {
    final newEnabled = !state.enabled;
    if (newEnabled) {
      final granted = await _notifService.requestPermission();
      if (!granted) return;
      await _scheduleAll();
    } else {
      await _notifService.cancelAll();
    }
    state = state.copyWith(enabled: newEnabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, newEnabled);
  }

  Future<void> updateTime(String meal, int hour, int minute) async {
    switch (meal) {
      case 'breakfast':
        state = state.copyWith(breakfastHour: hour, breakfastMinute: minute);
        break;
      case 'lunch':
        state = state.copyWith(lunchHour: hour, lunchMinute: minute);
        break;
      case 'dinner':
        state = state.copyWith(dinnerHour: hour, dinnerMinute: minute);
        break;
    }
    await _savePrefs();
    if (state.enabled) await _scheduleAll();
  }

  Future<void> _scheduleAll() async {
    await _notifService.cancelAll();
    await _notifService.scheduleDailyReminder(
      id: 0,
      title: 'Breakfast Time 🍳',
      body: 'Don\'t forget to log your breakfast!',
      hour: state.breakfastHour,
      minute: state.breakfastMinute,
    );
    await _notifService.scheduleDailyReminder(
      id: 1,
      title: 'Lunch Time 🥗',
      body: 'Remember to log your lunch!',
      hour: state.lunchHour,
      minute: state.lunchMinute,
    );
    await _notifService.scheduleDailyReminder(
      id: 2,
      title: 'Dinner Time 🍽️',
      body: 'Time to log your dinner!',
      hour: state.dinnerHour,
      minute: state.dinnerMinute,
    );
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyBreakfastH, state.breakfastHour);
    await prefs.setInt(_keyBreakfastM, state.breakfastMinute);
    await prefs.setInt(_keyLunchH, state.lunchHour);
    await prefs.setInt(_keyLunchM, state.lunchMinute);
    await prefs.setInt(_keyDinnerH, state.dinnerHour);
    await prefs.setInt(_keyDinnerM, state.dinnerMinute);
  }
}
