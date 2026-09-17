package com.bjw.smsforward

import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okio.IOException
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

object ForwardSender {
    suspend fun send(channel: JSONObject, title: String?, text: String?): Boolean =
        when (channel.optString("type")) {
            "email" -> sendEmail(title, text, channel)
            "discord" -> sendDiscord(title, text, channel)
            "slack" -> sendSlack(title, text, channel)
            "sms" -> sendSms(title, text, channel)
            else -> false
        }

    private suspend fun sendEmail(title: String?, text: String?, channel: JSONObject): Boolean =
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
                    setSubject(title ?: "(제목 없음)")
                    setText(text ?: "(내용 없음)")
                }
                Transport.send(message)
                true
            } catch (e: Exception) {
                Log.e("ForwardSender", "sendEmail failed", e)
                false
            }
        }

    private suspend fun sendDiscord(title: String?, text: String?, channel: JSONObject): Boolean =
        withContext(Dispatchers.IO) {
            val webhookUrl = channel.optString("webhookUrl")

            val embed = JSONObject().apply {
                put("title", title ?: "(제목 없음)")
                put("description", text ?: "(내용 없음)")
            }
            val json = JSONObject().apply {
                put("embeds", JSONArray().put(embed))
            }

            val requestBody = json.toString().toRequestBody("application/json".toMediaType())
            val request = Request.Builder()
                .url(webhookUrl)
                .post(requestBody)
                .build()

            try {
                HttpClientProvider.client.newCall(request).execute().use { response ->
                    response.isSuccessful
                }
            } catch (e: IOException) {
                false
            }
        }

    private fun sendSlack(title: String?, text: String?, channel: JSONObject): Boolean {
        return false
    }

    private fun sendSms(title: String?, text: String?, channel: JSONObject): Boolean {
        return false
    }
}
