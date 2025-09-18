package com.example.smart_sphere

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onStart() {
        super.onStart()

        // Create notification channel for Android 13+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "background_service", // must match your background service ID
                "Background Service",
                NotificationManager.IMPORTANCE_LOW
            )
            channel.description = "Notifications for background service"

            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }
}
