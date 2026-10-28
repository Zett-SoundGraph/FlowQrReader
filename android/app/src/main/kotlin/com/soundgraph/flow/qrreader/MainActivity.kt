package com.soundgraph.flow.qrreader

import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.InputDevice
import android.view.KeyEvent
import android.view.MotionEvent
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SCANNER_CHANNEL = "com.sg.scanner/scanner"
    private var scannerChannel: MethodChannel? = null

    // Native-backed persistence for the on-device role picker
    // (DeviceRoleDataSource) — a plain MethodChannel over Android's own
    // SharedPreferences API instead of the `shared_preferences` Flutter
    // plugin, whose Android implementation requires minSdk 24+ and would
    // otherwise conflict with this device's minSdk 23 (real scanner
    // hardware here runs Android 6.0.1).
    private val PREFS_CHANNEL = "com.sg.qr_reader/prefs"
    private val PREFS_NAME = "qr_reader_prefs"
    private val DEVICE_ROLE_KEY = "device_role"

    private val handler = Handler(Looper.getMainLooper())
    private var barcodeBuffer = StringBuilder()

    private val clearBufferRunnable = Runnable {
        if (barcodeBuffer.isNotEmpty()) {
            Log.w("SCANNER", "⚠️ 1.5초 입력 없음 — 버퍼 초기화: $barcodeBuffer")
            barcodeBuffer.clear()
        }
    }

    override fun onStart() {
        super.onStart()
        WatchdogService.isMainActivityRunning = true
        startService(Intent(this, WatchdogService::class.java))
    }

    override fun onStop() {
        super.onStop()
        WatchdogService.isMainActivityRunning = false
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        scannerChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SCANNER_CHANNEL)
        Log.d("SCANNER", "✅ 스캐너 채널 초기화 완료")

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PREFS_CHANNEL)
            .setMethodCallHandler { call, result ->
                val prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
                when (call.method) {
                    "getDeviceRole" -> result.success(prefs.getString(DEVICE_ROLE_KEY, null))
                    "setDeviceRole" -> {
                        val value = call.arguments as? String
                        prefs.edit().putString(DEVICE_ROLE_KEY, value).apply()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    // This kiosk (a plain STB with an HDMI monitor, no touch panel) has no
    // real UI input device at all besides the hardware scanner's keyboard
    // wedge (dispatchKeyEvent below) — a mouse plugged in for
    // testing/debugging generates MotionEvents that reach Flutter's own
    // Android-side pointer processing, which calls HashMap.getOrDefault
    // internally. That method doesn't exist on this device's Android 6.0.1
    // (added in API 24) and throws NoSuchMethodError, crashing the whole
    // app — confirmed via logcat. Swallowing mouse-sourced events here,
    // before they ever reach Flutter, avoids that call path entirely.
    // Scoped to SOURCE_MOUSE/SOURCE_TOUCHPAD only (matching
    // dispatchKeyEvent's own existing filter below) rather than the wider
    // SOURCE_CLASS_POINTER, so a real touchscreen would still work fine if
    // this same build ever ran on hardware that has one.
    private fun isFromMouse(source: Int): Boolean =
        (source and InputDevice.SOURCE_MOUSE) != 0 ||
            (source and InputDevice.SOURCE_TOUCHPAD) != 0

    override fun dispatchGenericMotionEvent(event: MotionEvent): Boolean {
        if (isFromMouse(event.source)) return true
        return super.dispatchGenericMotionEvent(event)
    }

    override fun dispatchTouchEvent(event: MotionEvent): Boolean {
        if (isFromMouse(event.source)) return true
        return super.dispatchTouchEvent(event)
    }

    private fun resolveChar(event: KeyEvent): Int {
        var unicodeChar = event.unicodeChar
        if (unicodeChar >= 32) return unicodeChar

        // Realtek STB 키맵이 Shift 조합 특수문자를 0으로 반환하는 경우 수동 매핑
        val shift = (event.metaState and
                (KeyEvent.META_SHIFT_ON or KeyEvent.META_SHIFT_LEFT_ON or KeyEvent.META_SHIFT_RIGHT_ON)) != 0
        unicodeChar = when (event.keyCode) {
            KeyEvent.KEYCODE_BACKSLASH  -> if (shift) '|'.code else '\\'.code
            KeyEvent.KEYCODE_SEMICOLON  -> if (shift) ':'.code  else ';'.code
            KeyEvent.KEYCODE_MINUS      -> if (shift) '_'.code  else '-'.code
            KeyEvent.KEYCODE_PERIOD     -> '.'.code
            KeyEvent.KEYCODE_COMMA      -> ','.code
            KeyEvent.KEYCODE_SLASH      -> if (shift) '?'.code  else '/'.code
            else -> 0
        }
        return unicodeChar
    }

    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        val source = event.source
        val isMouse = (source and InputDevice.SOURCE_MOUSE) != 0
                || (source and InputDevice.SOURCE_TOUCHPAD) != 0
        if (isMouse) return super.dispatchKeyEvent(event)

        if (event.action == KeyEvent.ACTION_DOWN && event.repeatCount == 0) {
            handler.removeCallbacks(clearBufferRunnable)

            val keyCode = event.keyCode
            if (keyCode == KeyEvent.KEYCODE_ENTER || keyCode == KeyEvent.KEYCODE_NUMPAD_ENTER) {
                if (barcodeBuffer.isNotEmpty()) {
                    val finalBarcode = barcodeBuffer.toString().trim()
                    barcodeBuffer.clear()
                    Log.d("SCANNER", "🎯 스캔 완료: $finalBarcode")
                    handler.post {
                        scannerChannel?.invokeMethod("onScan", finalBarcode)
                    }
                }
                return true
            } else {
                val unicodeChar = resolveChar(event)
                if (unicodeChar >= 32) {
                    barcodeBuffer.append(unicodeChar.toChar())
                }
                handler.postDelayed(clearBufferRunnable, 1500)
                return true
            }
        }
        return super.dispatchKeyEvent(event)
    }
}
