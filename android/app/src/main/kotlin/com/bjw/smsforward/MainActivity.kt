package com.bjw.smsforward

import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import androidx.core.graphics.drawable.toBitmap
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import java.io.ByteArrayOutputStream
import androidx.core.content.edit
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
        val prefs = context.getSharedPreferences("smsforward_data", MODE_PRIVATE)

        val methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.bjw.smsforward")
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "loadInstalledApps" -> {
                    val pm = context.packageManager
                    val intent =
                        Intent(Intent.ACTION_MAIN).apply { addCategory(Intent.CATEGORY_LAUNCHER) }
                    val resolveInfos = pm.queryIntentActivities(intent, PackageManager.MATCH_ALL)

                    val apps = resolveInfos
                        .mapNotNull { it.activityInfo }
                        .distinctBy { it.packageName }
                        .map { resolveInfo ->
                            val appInfo = resolveInfo.applicationInfo
                            val stream = ByteArrayOutputStream()
                            pm.getApplicationIcon(appInfo).toBitmap()
                                .compress(Bitmap.CompressFormat.PNG, 100, stream)

                            mapOf(
                                "packageName" to appInfo.packageName,
                                "appName" to pm.getApplicationLabel(appInfo).toString(),
                                "icon" to stream.toByteArray(),
                            )
                        }
                    result.success(apps)
                }

                "notificationAccessSettings" -> {
                    val enabled = NotificationManagerCompat.getEnabledListenerPackages(context)
                        .contains(context.packageName)
                    if (!enabled) {
                        startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }

                "saveChannels" -> {
                    val channels = call.arguments as? List<*>
                    prefs.edit { putString("channels", JSONArray(channels).toString()) }
                    result.success(null)
                }

                "saveFilters" -> {
                    val filters = call.arguments as? List<*>
                    prefs.edit { putString("filters", JSONArray(filters).toString()) }
                    result.success(null)
                }

                "retryForward" -> {
                    val id = (call.argument<Number>("id"))?.toLong()
                    if (id == null) {
                        result.success(false)
                    } else {
                        val db = AppDatabase.getInstance(applicationContext)
                        CoroutineScope(Dispatchers.IO).launch {
                            val log = db.forwardLogDao().getById(id)
                            val channels =
                                JSONArray(prefs.getString("channels", "[]")).toObjectList()
                            val channel =
                                channels.firstOrNull { it.optString("id") == log?.channelId }
                            val success = if (log != null && channel != null) {
                                ForwardSender.send(channel, log.title, log.body)
                            } else {
                                false
                            }
                            db.forwardLogDao().updateResult(id, success, System.currentTimeMillis())
                            withContext(Dispatchers.Main) {
                                result.success(success)
                            }
                        }
                    }
                }

                "getForwardLogs" -> {
                    val db = AppDatabase.getInstance(applicationContext)
                    CoroutineScope(Dispatchers.IO).launch {
                        val logs = db.forwardLogDao().getAll()
                        val logMaps = logs.map { log ->
                            mapOf(
                                "id" to log.id,
                                "packageName" to log.packageName,
                                "timestamp" to log.timestamp,
                                "title" to log.title,
                                "filterName" to log.filterName,
                                "channelType" to log.channelType,
                                "success" to log.success
                            )
                        }
                        withContext(Dispatchers.Main) {
                            result.success(logMaps)
                        }
                    }
                }
            }
        }
    }

    companion object {
        const val ENGINE_ID = "main_engine"
    }
}
