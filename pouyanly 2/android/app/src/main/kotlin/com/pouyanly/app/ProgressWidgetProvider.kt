package com.pouyanly.app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews

class ProgressWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        val data = context.getSharedPreferences("pouyanly_widget", Context.MODE_PRIVATE)
        val todayXp = data.getInt("todayXp", 0)
        val goalXp = data.getInt("dailyGoalXp", 50).coerceAtLeast(1)
        val lessons = data.getInt("lessonsToday", 0)
        val progress = ((todayXp * 100) / goalXp).coerceIn(0, 100)
        ids.forEach { id ->
            val views = RemoteViews(context.packageName, R.layout.pouyanly_progress_widget)
            views.setTextViewText(R.id.widget_progress_title, "پیشرفت امروز")
            views.setTextViewText(R.id.widget_progress_value, "$todayXp / $goalXp XP")
            views.setTextViewText(R.id.widget_lessons_value, "$lessons درس تکمیل‌شده")
            views.setProgressBar(R.id.widget_progress_bar, 100, progress, false)
            manager.updateAppWidget(id, views)
        }
    }
}