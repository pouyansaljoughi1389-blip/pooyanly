package com.pouyanly.app

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class DailyProgressWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        val lessons = widgetData.getString("dailyLessons", "0") ?: "0"
        val xp = widgetData.getString("dailyXp", "0") ?: "0"
        val progress = (widgetData.getString("dailyPercent", "0") ?: "0").toIntOrNull()?.coerceIn(0, 100) ?: 0

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.daily_progress_widget).apply {
                setTextViewText(R.id.widget_lessons, "$lessons درس امروز")
                setTextViewText(R.id.widget_xp, "+$xp XP")
                setTextViewText(R.id.widget_percent, "$progress٪")
                setProgressBar(R.id.widget_progress, 100, progress, false)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
