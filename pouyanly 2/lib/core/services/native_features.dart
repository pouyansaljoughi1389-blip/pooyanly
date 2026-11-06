import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Small Android integrations that do not require a cloud account.
class NativeFeatures {
  NativeFeatures._();

  static const MethodChannel _channel = MethodChannel('pouyanly/native');

  static Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyReminderEnabled', true);
    await prefs.setInt('dailyReminderHour', hour);
    await prefs.setInt('dailyReminderMinute', minute);
    try {
      await _channel.invokeMethod<void>('scheduleDailyReminder', {'hour': hour, 'minute': minute});
    } on PlatformException {
      // The app remains usable if Android notification permission is denied.
    } on MissingPluginException {
      // Non-Android platforms simply skip this Android-only feature.
    }
  }

  static Future<void> cancelDailyReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dailyReminderEnabled', false);
    try {
      await _channel.invokeMethod<void>('cancelDailyReminder');
    } on PlatformException {
      // Permission or OS restrictions should not block learning.
    } on MissingPluginException {}
  }

  static Future<void> restoreDailyReminder() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('dailyReminderEnabled') == false) return;
    await scheduleDailyReminder(
      hour: prefs.getInt('dailyReminderHour') ?? 20,
      minute: prefs.getInt('dailyReminderMinute') ?? 0,
    );
  }

  static Future<Map<String, int>> loadReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hour': prefs.getInt('dailyReminderHour') ?? 20,
      'minute': prefs.getInt('dailyReminderMinute') ?? 0,
    };
  }

  static Future<void> updateProgressWidget({
    required int todayXp,
    required int dailyGoalXp,
    required int lessonsToday,
  }) async {
    try {
      await _channel.invokeMethod<void>('updateProgressWidget', {
        'todayXp': todayXp,
        'dailyGoalXp': dailyGoalXp,
        'lessonsToday': lessonsToday,
      });
    } on PlatformException {
      // Widget support is Android-only and optional.
    } on MissingPluginException {}
  }
}