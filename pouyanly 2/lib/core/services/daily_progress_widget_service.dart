import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter/services.dart';

class DailyProgressWidgetService {
  DailyProgressWidgetService._();

  static Future<void> sync({
    required int lessons,
    required int xp,
    required int percent,
  }) async {
    try {
      if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
      await HomeWidget.saveWidgetData<String>('dailyLessons', lessons.toString());
      await HomeWidget.saveWidgetData<String>('dailyXp', xp.toString());
      await HomeWidget.saveWidgetData<String>('dailyPercent', percent.clamp(0, 100).toString());
      await HomeWidget.updateWidget(androidName: 'DailyProgressWidgetProvider');
    } on MissingPluginException {
      // Widget channels are not registered in unit tests or unsupported hosts.
    } on PlatformException {
      // Widget refresh is optional and must never interrupt a learning session.
    } catch (_) {
      // Keep learning available if the launcher widget cannot be refreshed.
    }
  }
}
