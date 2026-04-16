package com.example.droid_whisper

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * MainActivity
 *
 * Sets up the MethodChannel bridge between Flutter and native Android.
 *
 * Channel name : "droid_whisper/overlay"
 *
 * Flutter → Native calls
 * ──────────────────────
 * hasOverlayPermission   → Boolean
 * requestOverlayPermission → (opens Settings)
 * startFloatingWidget    → starts FloatingWidgetService
 * stopFloatingWidget     → stops FloatingWidgetService
 * recordingStarted       → tells the native service to show full-screen overlay
 * recordingStopped       → tells the native service to return to bubble
 *
 * Native → Flutter calls (invoked on the channel from the service)
 * ────────────────────────────────────────────────────────────────
 * onWidgetStartRecording → Flutter calls TranscriptionNotifier.startRecording()
 * onWidgetStopRecording  → Flutter calls TranscriptionNotifier.stopRecordingAndTranscribe()
 */
class MainActivity : FlutterActivity() {

    companion object {
        private const val OVERLAY_CHANNEL = "droid_whisper/overlay"
        private const val OVERLAY_PERMISSION_REQUEST_CODE = 9001
    }

    private var overlayChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        overlayChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            OVERLAY_CHANNEL
        ).also { channel ->
            FloatingWidgetServiceHolder.attach(channel)
            channel.setMethodCallHandler { call, result ->
                when (call.method) {

                    // ── Query permission ─────────────────────────────────
                    "hasOverlayPermission" -> {
                        result.success(Settings.canDrawOverlays(this))
                    }

                    // ── Request permission ───────────────────────────────
                    "requestOverlayPermission" -> {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            Uri.parse("package:$packageName")
                        )
                        startActivityForResult(intent, OVERLAY_PERMISSION_REQUEST_CODE)
                        result.success(null)
                    }

                    // ── Start floating widget ────────────────────────────
                    "startFloatingWidget" -> {
                        if (!Settings.canDrawOverlays(this)) {
                            result.error(
                                "NO_PERMISSION",
                                "Overlay permission not granted",
                                null
                            )
                            return@setMethodCallHandler
                        }
                        FloatingWidgetService.start(this, OVERLAY_CHANNEL)
                        result.success(null)
                    }

                    // ── Stop floating widget ─────────────────────────────
                    "stopFloatingWidget" -> {
                        FloatingWidgetService.stop(this)
                        result.success(null)
                    }

                    // ── Notify service that Flutter recording has started ─
                    "recordingStarted" -> {
                        FloatingWidgetService.instance?.onRecordingStarted()
                        result.success(null)
                    }

                    // ── Notify service that Flutter recording has stopped ─
                    "recordingStopped" -> {
                        FloatingWidgetService.instance?.onRecordingStopped()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
        }
    }



    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == OVERLAY_PERMISSION_REQUEST_CODE) {
            val granted = Settings.canDrawOverlays(this)
            overlayChannel?.invokeMethod(
                "onOverlayPermissionResult",
                mapOf("granted" to granted)
            )
        }
    }
}

/**
 * Package-level singleton so [FloatingWidgetService] can receive the channel
 * without a Binder connection.
 */
object FloatingWidgetServiceHolder {
    private var channel: MethodChannel? = null

    fun attach(ch: MethodChannel) { channel = ch }
    fun getChannel(): MethodChannel? = channel
    fun detach() { channel = null }
}
