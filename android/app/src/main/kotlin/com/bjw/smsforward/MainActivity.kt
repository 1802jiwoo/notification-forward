package com.bjw.smsforward

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import androidx.core.graphics.drawable.toBitmap
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val prefs = context.getSharedPreferences("smsforward_data", Context.MODE_PRIVATE)
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
                    if(!enabled) {
                        startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }

                "saveChannels" -> {
                    val channels = call.arguments as? List<*>
                    prefs.edit().putString("channels", JSONArray(channels).toString()).apply()
                    result.success(null)
                }

                "saveFilters" -> {
                    val filters = call.arguments as? List<*>
                    prefs.edit().putString("filters", JSONArray(filters).toString()).apply()
                    result.success(null)
                }
            }
        }
    }
}
