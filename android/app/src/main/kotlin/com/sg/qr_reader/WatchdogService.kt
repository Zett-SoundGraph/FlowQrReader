package com.sg.qr_reader

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log

class WatchdogService : Service() {

    companion object {
        var isMainActivityRunning = false
    }

    private val handler = Handler(Looper.getMainLooper())
    private val checkInterval = 30_000L

    private val checkRunnable = object : Runnable {
        override fun run() {
            if (!isMainActivityRunning) {
                Log.d("WATCHDOG", "앱이 꺼져 있음 — 재시작")
                val intent = Intent(applicationContext, MainActivity::class.java).apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                startActivity(intent)
            }
            handler.postDelayed(this, checkInterval)
        }
    }

    override fun onCreate() {
        super.onCreate()
        startForeground(1, buildNotification())
        handler.postDelayed(checkRunnable, checkInterval)
        Log.d("WATCHDOG", "워치독 서비스 시작됨")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return START_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(checkRunnable)
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun buildNotification(): Notification {
        val channelId = "watchdog_channel"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Barcode Scanner",
                NotificationManager.IMPORTANCE_MIN
            )
            getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
            return Notification.Builder(this, channelId)
                .setContentTitle("Barcode Scanner")
                .setContentText("실행 중")
                .setSmallIcon(android.R.drawable.ic_menu_view)
                .build()
        } else {
            @Suppress("DEPRECATION")
            return Notification.Builder(this)
                .setContentTitle("Barcode Scanner")
                .setContentText("실행 중")
                .setSmallIcon(android.R.drawable.ic_menu_view)
                .setPriority(Notification.PRIORITY_MIN)
                .build()
        }
    }
}
