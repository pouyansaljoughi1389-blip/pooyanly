package com.pouyanly.app

import android.Manifest
import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Calendar

class MainActivity : FlutterActivity() {
    private val channelName = "pouyanly/native"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= 33 &&
            checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions(arrayOf(Manifest.permission.POST_NOTIFICATIONS), 8102)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleDailyReminder" -> {
                        val hour = (call.argument<Int>("hour") ?: 20).coerceIn(0, 23)
                        val minute = (call.argument<Int>("minute") ?: 0).coerceIn(0, 59)
                        scheduleDailyReminder(hour, minute)
                        result.success(null)
                    }
                    "cancelDailyReminder" -> {
                        cancelDailyReminder()
                        result.success(null)
                    }
                    "updateProgressWidget" -> {
                        val todayXp = call.argument<Int>("todayXp") ?: 0
                        val goalXp = call.argument<Int>("dailyGoalXp") ?: 50
                        val lessonsToday = call.argument<Int>("lessonsToday") ?: 0
                        updateProgressWidget(todayXp, goalXp, lessonsToday)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun reminderPendingIntent(): PendingIntent {
        val intent = Intent(this, ReminderReceiver::class.java)
        return PendingIntent.getBroadcast(
            this, 501, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun scheduleDailyReminder(hour: Int, minute: Int) {
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            if (timeInMillis <= System.currentTimeMillis()) add(Calendar.DAY_OF_YEAR, 1)
        }
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.setInexactRepeating(
            AlarmManager.RTC_WAKEUP,
            calendar.timeInMillis,
            AlarmManager.INTERVAL_DAY,
            reminderPendingIntent()
        )
    }

    private fun cancelDailyReminder() {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(reminderPendingIntent())
    }

    private fun updateProgressWidget(todayXp: Int, goalXp: Int, lessonsToday: Int) {
        getSharedPreferences("pouyanly_widget", Context.MODE_PRIVATE).edit()
            .putInt("todayXp", todayXp.coerceAtLeast(0))
            .putInt("dailyGoalXp", goalXp.coerceAtLeast(1))
            .putInt("lessonsToday", lessonsToday.coerceAtLeast(0))
            .apply()
        val manager = AppWidgetManager.getInstance(this)
        val component = ComponentName(this, ProgressWidgetProvider::class.java)
        val ids = manager.getAppWidgetIds(component)
        if (ids.isNotEmpty()) ProgressWidgetProvider().onUpdate(this, manager, ids)
    }
}