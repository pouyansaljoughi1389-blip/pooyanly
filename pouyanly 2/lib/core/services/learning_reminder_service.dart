import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LearningReminderService {
  LearningReminderService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<void> requestPermission() async {
    await initialize();
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> cancelAll() async {
    await initialize();
    for (var id = 8100; id < 8107; id++) {
      await _plugin.cancel(id);
    }
  }

  /// Weekday indexes follow the Persian settings UI:
  /// 0=Saturday, 1=Sunday, ... 6=Friday.
  static Future<void> scheduleWeekly({
    required TimeOfDay time,
    required Set<int> activeDays,
  }) async {
    await requestPermission();
    await cancelAll();
    if (activeDays.isEmpty) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'pouyanly_learning_reminders',
        'یادآور یادگیری زبان',
        channelDescription: 'یادآوری برای تمرین روزانهٔ زبان انگلیسی',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    const weekdays = <int>[
      DateTime.saturday,
      DateTime.sunday,
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
    ];
    final now = tz.TZDateTime.now(tz.local);
    for (final index in activeDays) {
      if (index < 0 || index > 6) continue;
      final weekday = weekdays[index];
      var daysAhead = (weekday - now.weekday + 7) % 7;
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      ).add(Duration(days: daysAhead));
      if (!scheduled.isAfter(now)) {
        daysAhead += 7;
        scheduled = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        ).add(Duration(days: daysAhead));
      }
      await _plugin.zonedSchedule(
        8100 + index,
        'وقت تمرین انگلیسیه! 📚',
        'چند دقیقه تمرین امروز، تو را به هدفت نزدیک‌تر می‌کند.',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }
}
