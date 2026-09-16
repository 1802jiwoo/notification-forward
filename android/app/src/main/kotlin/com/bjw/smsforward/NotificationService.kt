package com.bjw.smsforward

import android.app.Notification
import android.os.Bundle
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject
import java.util.Properties
import javax.mail.Authenticator
import javax.mail.Message
import javax.mail.PasswordAuthentication
import javax.mail.Session
import javax.mail.Transport
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage

fun JSONArray.toObjectList(): List<JSONObject> = (0 until length()).map { getJSONObject(it) }
fun JSONArray.toStringList(): List<String> = (0 until length()).map { getString(it) }

class NotificationService : NotificationListenerService() {
    private val serviceScope = CoroutineScope(Dispatchers.IO + SupervisorJob())

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

        for (filter in filters) {
            val targetApps = filter.optJSONArray("targetApps")!!.toStringList()
            if (targetApps.isNotEmpty() && !targetApps.contains(packageName)) continue

            val keywords = filter.optJSONArray("keywords")!!.toStringList()
            val isMatched = keywords.any { keyword ->
                when (filter.optString("keywordTarget")) {
                    "titleOnly" -> title != null && title.contains(keyword)
                    "bodyOnly" -> text != null && text.contains(keyword)
                    else -> (title != null && title.contains(keyword)) || (text != null && text.contains(
                        keyword
                    ))
                }
            }

            if (!isMatched) continue

            val channelId = filter.optString("channelId")
            val channel = channels.firstOrNull { it.optString("id") == channelId } ?: continue
            serviceScope.launch {
                val result = when (channel.optString("type")) {
                    "email" -> sendEmail(extras, channel)
                    "discord" -> sendDiscord(extras)
                    "slack" -> sendSlack(extras)
                    "sms" -> sendSms(extras)
                    else -> false
                }

                val db = AppDatabase.getInstance(applicationContext)
                db.forwardLogDao().insert(
                    ForwardLog(
                        packageName = packageName,
                        timestamp = System.currentTimeMillis(),
                        title = title,
                        filterName = filter.optString("name"),
                        channelType = channel.optString("type"),
                        success = result
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

    private suspend fun sendEmail(extras: Bundle, channel: JSONObject): Boolean =
        withContext(Dispatchers.IO) {
            val emailAddress = channel.optString("senderEmail")
            val to =
                channel.optJSONArray("recipientEmails")?.toStringList()?.joinToString(",") ?: ""

            val props = Properties().apply {
                put("mail.smtp.host", channel.optString("smtpHost"))
                put("mail.smtp.port", channel.optString("smtpPort"))
                put("mail.smtp.auth", "true")
                put("mail.smtp.starttls.enable", "true")
            }

            val session = Session.getInstance(props, object : Authenticator() {
                override fun getPasswordAuthentication(): PasswordAuthentication {
                    return PasswordAuthentication(emailAddress, channel.optString("appPassword"))
                }
            })

            try {
                val message = MimeMessage(session).apply {
                    setFrom(InternetAddress(emailAddress))
                    setRecipients(Message.RecipientType.TO, InternetAddress.parse(to))
                    setSubject(extras.getString(Notification.EXTRA_TITLE))
                    setText(extras.getString(Notification.EXTRA_TEXT))
                }
                Transport.send(message)
                true
            } catch (e: Exception) {
                Log.e("NotificationService", "sendEmail failed", e)
                false
            }
        }

    private fun sendDiscord(extras: Bundle): Boolean {
        return false
    }

    private fun sendSlack(extras: Bundle): Boolean {
        return false
    }

    private fun sendSms(extras: Bundle): Boolean {
        return false
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        super.onNotificationRemoved(sbn)
    }
}