package com.example.pushup_counter

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.app.PendingIntent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class PushupWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val pushupCount = widgetData.getInt("pushup_count", 0)

        val views = RemoteViews(context.packageName, R.layout.pushup_widget)
        views.setTextViewText(R.id.pushup_count, pushupCount.toString())

        // Set click listener to open the app
        val intent = Intent(context, MainActivity::class.java)
        intent.putExtra("widget_clicked", true)
        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.pushup_count, pendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
