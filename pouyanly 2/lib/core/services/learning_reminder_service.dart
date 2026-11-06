import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

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
    await _plugin.initialize(settings: settings);
    _initialized = true;
  }

  static Future<void> requestPermission() async {
    await initialize();
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('learningReminderEnabled') == false) return;
    final days = (prefs.getStringList('learningReminderDays') ?? ['1', '2', '3', '4', '5'])
        .map((value) => int.tryParse(value))
        .whereType<int>()
        .toSet();
    await scheduleWeekly(
      time: TimeOfDay(
        hour: prefs.getInt('learningReminderHour') ?? 20,
        minute: prefs.getInt('learningReminderMinute') ?? 0,
      ),
      activeDays: days,
    );
  }

  static Future<void> cancelAll() async {
    await initialize();
    for (var id = 8100; id < 8107; id++) {
      await _plugin.cancel(id: id);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('learningReminderEnabled', activeDays.isNotEmpty);
    await prefs.setInt('learningReminderHour', time.hour);
    await prefs.setInt('learningReminderMinute', time.minute);
    await prefs.setStringList('learningReminderDays', activeDays.map((day) => day.toString()).toList());
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
      var targetDay = DateTime(now.year, now.month, now.day).add(Duration(days: daysAhead));
      var scheduled = tz.TZDateTime(
        tz.local, targetDay.year, targetDay.month, targetDay.day, time.hour, time.minute,
      );
      if (!scheduled.isAfter(now)) {
        targetDay = targetDay.add(const Duration(days: 7));
        scheduled = tz.TZDateTime(
          tz.local, targetDay.year, targetDay.month, targetDay.day, time.hour, time.minute,
        );
      }
      await _plugin.zonedSchedule(
        id: 8100 + index,
        title: 'وقت تمرین انگلیسیه! 📚',
        body: 'چند دقیقه تمرین امروز، تو را به هدفت نزدیک‌تر می‌کند.',
        scheduledDate: scheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }
}
