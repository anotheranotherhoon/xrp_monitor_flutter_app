package com.anotherhoon.xrpmonitor

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "xrp_monitor/native"
    private val NOTIFICATION_CHANNEL_ID = "xrp_monitor_notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Create notification channel
        createNotificationChannel()
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "showNotification" -> {
                    val title = call.argument<String>("title") ?: "XRP Monitor"
                    val message = call.argument<String>("message") ?: ""
                    val withVibration = call.argument<Boolean>("withVibration") ?: true
                    
                    showNotification(title, message)
                    if (withVibration) {
                        vibrate(500)
                    }
                    result.success(null)
                }
                "vibrate" -> {
                    val duration = call.argument<Int>("duration") ?: 500
                    vibrate(duration)
                    result.success(null)
                }
                "vibratePattern" -> {
                    val pattern = call.argument<List<Int>>("pattern") ?: listOf(500)
                    vibratePattern(pattern)
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "XRP Monitor Notifications"
            val descriptionText = "XRP Monitor 앱 알림"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(NOTIFICATION_CHANNEL_ID, name, importance).apply {
                description = descriptionText
                enableVibration(true)
            }
            
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun showNotification(title: String, message: String) {
        val builder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle(title)
            .setContentText(message)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setVibrate(longArrayOf(0, 500, 100, 500))

        with(NotificationManagerCompat.from(this)) {
            notify(System.currentTimeMillis().toInt(), builder.build())
        }
    }

    private fun vibrate(duration: Int) {
        val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            vibrator.vibrate(VibrationEffect.createOneShot(duration.toLong(), VibrationEffect.DEFAULT_AMPLITUDE))
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(duration.toLong())
        }
    }

    private fun vibratePattern(pattern: List<Int>) {
        val vibrator = getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        val patternArray = pattern.map { it.toLong() }.toLongArray()
        
        println("Android - Vibrating with pattern: ${patternArray.contentToString()}")
        
        if (!vibrator.hasVibrator()) {
            println("Android - Device has no vibrator!")
            return
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Android 8.0+ 에서는 VibrationEffect.createWaveform 사용
            try {
                // 진폭 배열 없이 패턴만 사용 (더 안정적)
                val vibrationEffect = VibrationEffect.createWaveform(patternArray, -1)
                vibrator.vibrate(vibrationEffect)
                println("Android - VibrationEffect.createWaveform used")
            } catch (e: Exception) {
                println("Android - VibrationEffect failed: ${e.message}")
                // 실패시 기본 진동으로 대체
                vibrator.vibrate(VibrationEffect.createOneShot(500, VibrationEffect.DEFAULT_AMPLITUDE))
            }
        } else {
            // Android 8.0 미만에서는 기존 방식 사용
            try {
                @Suppress("DEPRECATION")
                vibrator.vibrate(patternArray, -1)
                println("Android - Legacy vibrate used")
            } catch (e: Exception) {
                println("Android - Legacy vibrate failed: ${e.message}")
                @Suppress("DEPRECATION")
                vibrator.vibrate(500)
            }
        }
    }
}
