package com.bjw.smsforward

import android.app.Notification
import android.os.Bundle
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import android.view.Display
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject

fun JSONArray.toObjectList(): List<JSONObject> = (0 until length()).map { getJSONObject(it) }
fun JSONArray.toStringList(): List<String> = (0 until length()).map { getString(it) }

class NotificationService : NotificationListenerService() {
    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        super.onNotificationPosted(sbn)
        val prefs = getSharedPreferences("smsforward_data", MODE_PRIVATE)
        val filters = JSONArray(prefs.getString("filters", "[]")).toObjectList()
        val channels = JSONArray(prefs.getString("channels", "[]")).toObjectList()

        if (filters.isEmpty()) return
        if (sbn == null) return

        val packageName = sbn.packageName
        val extras = sbn.notification.extras
        val title = extras.getString(Notification.EXTRA_TITLE)
        val text = extras.getString(Notification.EXTRA_TEXT)

        Log.d("코툴린", title.toString())
        Log.d("코툴린", text.toString())

        for (filter in filters) {
            val targetApps = filter.optJSONArray("targetApps")!!.toStringList()
            if (targetApps.isNotEmpty() && !targetApps.contains(packageName)) continue

            val keywords = filter.optJSONArray("keywords")!!.toStringList()
            val isMatched = keywords.any { keyword ->
                when (filter.optString("keywordTarget")) {
                    "titleOnly" -> title != null && title.contains(keyword)
                    "bodyOnly" -> text != null && text.contains(keyword)
                    else -> (title != null && title.contains(keyword)) || (text != null && text.contains(keyword))
                }
            }

            if (!isMatched) continue

            val channelId = filter.optString("channelId")
            val channel = channels.firstOrNull { it.optString("id") == channelId } ?: continue
            when (channel.optString("type")) {
                "email" -> postEmail(extras)
                "discord" -> postDiscord(extras)
                "slack" -> postSlack(extras)
                "sms" -> postSms(extras)
            }

            val db = AppDatabase.getInstance(applicationContext)
            CoroutineScope(Dispatchers.IO).launch {
                db.forwardLogDao().insert(
                    ForwardLog(
                        packageName = packageName,
                        timestamp = System.currentTimeMillis(),
                        title = title,
                        filterName = filter.optString("name"),
                        channelType = channel.optString("type"),
                        success = true
                    )
                )
                db.forwardLogDao().trimTo(300)
                notifyFlutter()
            }
        }
    }

    private suspend fun notifyFlutter() {
        val engine = FlutterEngineCache.getInstance().get(MainActivity.ENGINE_ID) ?: return
        withContext(Dispatchers.Main) {
            MethodChannel(engine.dartExecutor.binaryMessenger, "com.bjw.smsforward")
                .invokeMethod("onForwardLogInserted", null)
        }
    }

    private fun postEmail(extras: Bundle) {
        Log.d("코틀린", "${extras.getString(Notification.EXTRA_TITLE)} 이메일 렛츠고")
    }

    private fun postDiscord(extras: Bundle) {}
    private fun postSlack(extras: Bundle) {}
    private fun postSms(extras: Bundle) {}

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        super.onNotificationRemoved(sbn)
    }
}