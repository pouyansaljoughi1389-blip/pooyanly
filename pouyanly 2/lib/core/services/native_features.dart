import 'package:flutter/services.dart';

/// Small Android integrations that do not require a cloud account.
class NativeFeatures {
  NativeFeatures._();

  static const MethodChannel _channel = MethodChannel('pouyanly/native');

  static Future<void> scheduleDailyReminder({required int hour, required int minute}) async {
    try {
      await _channel.invokeMethod<void>('scheduleDailyReminder', {'hour': hour, 'minute': minute});
    } on PlatformException {
      // The app remains usable if Android notification permission is denied.
    } on MissingPluginException {
      // Non-Android platforms simply skip this Android-only feature.
    }
  }

  static Future<void> cancelDailyReminder() async {
    try {
      await _channel.invokeMethod<void>('cancelDailyReminder');
    } on PlatformException {
      // Permission or OS restrictions should not block learning.
    } on MissingPluginException {}
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