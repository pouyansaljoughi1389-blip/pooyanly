import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

class DailyProgressWidgetService {
  DailyProgressWidgetService._();

  static Future<void> sync({
    required int lessons,
    required int xp,
    required int percent,
  }) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    await HomeWidget.saveWidgetData<String>('dailyLessons', lessons.toString());
    await HomeWidget.saveWidgetData<String>('dailyXp', xp.toString());
    await HomeWidget.saveWidgetData<String>('dailyPercent', percent.clamp(0, 100).toString());
    await HomeWidget.updateWidget(androidName: 'DailyProgressWidgetProvider');
  }
}
