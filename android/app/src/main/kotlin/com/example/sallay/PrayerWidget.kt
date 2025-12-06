package com.example.sallay

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class PrayerWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val prayerName = widgetData.getString("prayer_name", "Fajr")
                val prayerTime = widgetData.getString("prayer_time", "--:--")
                setTextViewText(R.id.widget_prayer_name, prayerName)
                setTextViewText(R.id.widget_prayer_time, prayerTime)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
