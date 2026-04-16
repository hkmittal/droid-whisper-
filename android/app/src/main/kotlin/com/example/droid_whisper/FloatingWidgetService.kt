package com.example.droid_whisper

import android.annotation.SuppressLint
import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.os.*
import android.view.*
import android.view.animation.DecelerateInterpolator
import android.widget.*
import androidx.core.app.NotificationCompat
import io.flutter.plugin.common.MethodChannel

/**
 * FloatingWidgetService
 *
 * A foreground Android Service that renders a draggable floating mic bubble
 * over all other apps using WindowManager + SYSTEM_ALERT_WINDOW permission.
 *
 * Communication back to Flutter goes through [MethodChannel] — specifically
 * it calls `onStartRecording` / `onStopRecording` on the Flutter side so the
 * existing TranscriptionNotifier handles all audio I/O.
 *
 * Layout modes
 * ─────────────
 * 1. IDLE    — small 56dp circular mic bubble, draggable anywhere
 * 2. RECORDING — full-screen dark overlay with a pulsing stop button & timer
 */
class FloatingWidgetService : Service() {

    companion object {
        const val CHANNEL_ID        = "droid_whisper_floating"
        const val NOTIF_ID          = 1001
        const val EXTRA_CHANNEL_NAME = "channel_name"

        var instance: FloatingWidgetService? = null

        /** Start the service. [channelName] must match the MethodChannel name in MainActivity. */
        fun start(context: Context, channelName: String) {
            val intent = Intent(context, FloatingWidgetService::class.java).apply {
                putExtra(EXTRA_CHANNEL_NAME, channelName)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            context.stopService(Intent(context, FloatingWidgetService::class.java))
        }
    }

    // ── Window manager & views ───────────────────────────────────────────────
    private lateinit var windowManager: WindowManager
    private var bubbleView: View? = null
    private var overlayView: View? = null

    // ── State ────────────────────────────────────────────────────────────────
    private var isRecording = false
    private var elapsedSeconds = 0
    private val timerHandler = Handler(Looper.getMainLooper())
    private lateinit var timerRunnable: Runnable
    private var timerTextView: TextView? = null

    // ── Flutter channel — retrieved from package-level holder ──────────────
    private val flutterChannel: MethodChannel?
        get() = FloatingWidgetServiceHolder.getChannel()

    // ────────────────────────────────────────────────────────────────────────
    // Service lifecycle
    // ────────────────────────────────────────────────────────────────────────

    override fun onCreate() {
        super.onCreate()
        instance = this
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForeground(NOTIF_ID, buildNotification())
        showBubble()
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        instance = null
        removeBubble()
        removeOverlay()
        timerHandler.removeCallbacksAndMessages(null)
        FloatingWidgetServiceHolder.detach()
        super.onDestroy()
    }

    // ────────────────────────────────────────────────────────────────────────
    // Public API called from MainActivity
    // ────────────────────────────────────────────────────────────────────────

    /** Called when Flutter reports that recording has actually started. */
    fun onRecordingStarted() {
        isRecording = true
        showFullScreenOverlay()
        startTimer()
    }

    /** Called when Flutter reports that recording has stopped / transcription begun. */
    fun onRecordingStopped() {
        isRecording = false
        stopTimer()
        removeOverlay()
        showBubble()
    }

    // ────────────────────────────────────────────────────────────────────────
    // Bubble (idle floating button)
    // ────────────────────────────────────────────────────────────────────────

    @SuppressLint("InflateParams")
    private fun showBubble() {
        if (bubbleView != null) return

        val bubble = buildBubbleView()
        val params = bubbleLayoutParams(56)

        windowManager.addView(bubble, params)
        bubbleView = bubble

        // Make it draggable
        setupDrag(bubble, params)

        // Tap → start recording
        bubble.setOnClickListener {
            requestRecordingStart()
        }
    }

    private fun removeBubble() {
        bubbleView?.let { windowManager.removeViewImmediate(it) }
        bubbleView = null
    }

    @SuppressLint("SetTextI18n")
    private fun buildBubbleView(): View {
        val size = dpToPx(56)
        val frame = FrameLayout(this)

        // Outer circle (primary colour)
        val circle = createCircle(size, Color.parseColor("#6750A4"))
        frame.addView(circle)

        // Mic icon
        val mic = ImageView(this).apply {
            setImageResource(android.R.drawable.ic_btn_speak_now)
            setColorFilter(Color.WHITE)
            val pad = dpToPx(14)
            setPadding(pad, pad, pad, pad)
        }
        frame.addView(mic, FrameLayout.LayoutParams(size, size))

        frame.layoutParams = ViewGroup.LayoutParams(size, size)
        frame.elevation = 12f
        return frame
    }

    // ────────────────────────────────────────────────────────────────────────
    // Full-screen recording overlay
    // ────────────────────────────────────────────────────────────────────────

    @SuppressLint("SetTextI18n")
    private fun showFullScreenOverlay() {
        if (overlayView != null) return
        removeBubble()

        val overlay = buildOverlayView()
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            overlayType(),
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        )

        windowManager.addView(overlay, params)
        overlayView = overlay

        // Animate in
        overlay.alpha = 0f
        overlay.animate().alpha(1f).setDuration(250).setInterpolator(DecelerateInterpolator()).start()
    }

    private fun removeOverlay() {
        overlayView?.let {
            windowManager.removeViewImmediate(it)
        }
        overlayView = null
    }

    @SuppressLint("SetTextI18n")
    private fun buildOverlayView(): View {
        val root = FrameLayout(this)
        root.setBackgroundColor(Color.parseColor("#CC000000")) // semi-transparent black

        // ── Centre content ──────────────────────────────────────────────────
        val content = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
        }

        // Recording indicator icon
        val recIcon = ImageView(this).apply {
            setImageResource(android.R.drawable.presence_video_busy)
            setColorFilter(Color.RED)
            val size = dpToPx(48)
            layoutParams = LinearLayout.LayoutParams(size, size).apply {
                gravity = Gravity.CENTER_HORIZONTAL
            }
        }
        content.addView(recIcon)

        // Timer text
        timerTextView = TextView(this).apply {
            text = "0:00"
            textSize = 52f
            setTextColor(Color.WHITE)
            gravity = Gravity.CENTER
            typeface = android.graphics.Typeface.MONOSPACE
            setPadding(0, dpToPx(20), 0, dpToPx(4))
        }
        content.addView(timerTextView)

        // "Recording…" label
        val label = TextView(this).apply {
            text = "Recording…"
            textSize = 16f
            setTextColor(Color.parseColor("#BBFFFFFF"))
            gravity = Gravity.CENTER
        }
        content.addView(label)

        // ── Stop button ─────────────────────────────────────────────────────
        val stopSize = dpToPx(72)
        val stopBtn = createCircle(stopSize, Color.parseColor("#B00020"))
        val stopIcon = ImageView(this).apply {
            setImageResource(android.R.drawable.ic_media_pause)
            setColorFilter(Color.WHITE)
            val pad = dpToPx(18)
            setPadding(pad, pad, pad, pad)
        }

        val stopFrame = FrameLayout(this).apply {
            addView(stopBtn, FrameLayout.LayoutParams(stopSize, stopSize))
            addView(stopIcon, FrameLayout.LayoutParams(stopSize, stopSize))
            layoutParams = LinearLayout.LayoutParams(stopSize, stopSize).apply {
                gravity = Gravity.CENTER_HORIZONTAL
                topMargin = dpToPx(40)
            }
            setOnClickListener { requestRecordingStop() }
        }
        content.addView(stopFrame)

        // "Stop & Transcribe" label
        val stopLabel = TextView(this).apply {
            text = "Stop & Transcribe"
            textSize = 12f
            setTextColor(Color.parseColor("#BBFFFFFF"))
            gravity = Gravity.CENTER
            val lp = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            lp.topMargin = dpToPx(8)
            layoutParams = lp
        }
        content.addView(stopLabel)

        val centerParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.WRAP_CONTENT,
            FrameLayout.LayoutParams.WRAP_CONTENT,
            Gravity.CENTER
        )
        root.addView(content, centerParams)

        // ── Cancel / close button (top-right) ─────────────────────────────
        val closeBtn = TextView(this).apply {
            text = "✕"
            textSize = 22f
            setTextColor(Color.parseColor("#AAFFFFFF"))
            gravity = Gravity.CENTER
            val size = dpToPx(44)
            layoutParams = FrameLayout.LayoutParams(size, size, Gravity.TOP or Gravity.END).apply {
                topMargin = dpToPx(48)
                marginEnd = dpToPx(16)
            }
            setOnClickListener { requestRecordingStop() }
        }
        root.addView(closeBtn)

        return root
    }

    // ────────────────────────────────────────────────────────────────────────
    // Timer
    // ────────────────────────────────────────────────────────────────────────

    private fun startTimer() {
        elapsedSeconds = 0
        timerRunnable = object : Runnable {
            override fun run() {
                elapsedSeconds++
                updateTimerDisplay()
                timerHandler.postDelayed(this, 1000)
            }
        }
        timerHandler.postDelayed(timerRunnable, 1000)
    }

    private fun stopTimer() {
        timerHandler.removeCallbacks(timerRunnable)
        elapsedSeconds = 0
    }

    private fun updateTimerDisplay() {
        val tv = timerTextView ?: return
        val m = elapsedSeconds / 60
        val s = elapsedSeconds % 60
        tv.text = String.format("%d:%02d", m, s)
    }

    // ────────────────────────────────────────────────────────────────────────
    // Flutter MethodChannel calls
    // ────────────────────────────────────────────────────────────────────────

    private fun requestRecordingStart() {
        flutterChannel?.invokeMethod("onWidgetStartRecording", null)
    }

    private fun requestRecordingStop() {
        flutterChannel?.invokeMethod("onWidgetStopRecording", null)
    }

    // ────────────────────────────────────────────────────────────────────────
    // Drag support
    // ────────────────────────────────────────────────────────────────────────

    @SuppressLint("ClickableViewAccessibility")
    private fun setupDrag(view: View, params: WindowManager.LayoutParams) {
        var initX = 0; var initY = 0
        var initTouchX = 0f; var initTouchY = 0f
        var isDragging = false
        val touchSlop = ViewConfiguration.get(this).scaledTouchSlop

        view.setOnTouchListener { _, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initX = params.x; initY = params.y
                    initTouchX = event.rawX; initTouchY = event.rawY
                    isDragging = false
                    true // Consume down to ensure we receive move/up
                }
                MotionEvent.ACTION_MOVE -> {
                    val dx = event.rawX - initTouchX
                    val dy = event.rawY - initTouchY
                    if (!isDragging && (Math.abs(dx) > touchSlop || Math.abs(dy) > touchSlop)) {
                        isDragging = true
                    }
                    if (isDragging) {
                        params.x = initX + dx.toInt()
                        params.y = initY + dy.toInt()
                        windowManager.updateViewLayout(view, params)
                    }
                    true
                }
                MotionEvent.ACTION_UP -> {
                    if (!isDragging) {
                        view.performClick()
                    }
                    true
                }
                else -> false
            }
        }
    }

    // ────────────────────────────────────────────────────────────────────────
    // Helpers
    // ────────────────────────────────────────────────────────────────────────

    private fun bubbleLayoutParams(sizeDp: Int): WindowManager.LayoutParams {
        val sizePx = dpToPx(sizeDp)
        return WindowManager.LayoutParams(
            sizePx, sizePx,
            overlayType(),
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        ).apply {
            gravity = Gravity.TOP or Gravity.START
            x = 100; y = 300
        }
    }

    private fun overlayType(): Int =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        else
            @Suppress("DEPRECATION") WindowManager.LayoutParams.TYPE_PHONE

    private fun createCircle(sizePx: Int, color: Int): View {
        val circle = View(this)
        val drawable = android.graphics.drawable.GradientDrawable().apply {
            shape = android.graphics.drawable.GradientDrawable.OVAL
            setColor(color)
        }
        circle.background = drawable
        circle.layoutParams = FrameLayout.LayoutParams(sizePx, sizePx)
        return circle
    }

    private fun dpToPx(dp: Int): Int =
        (dp * resources.displayMetrics.density + 0.5f).toInt()

    // ────────────────────────────────────────────────────────────────────────
    // Notification
    // ────────────────────────────────────────────────────────────────────────

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "DroidWhisper Floating Widget",
                NotificationManager.IMPORTANCE_LOW
            ).apply { description = "Keeps the floating mic widget alive" }
            getSystemService(NotificationManager::class.java)
                ?.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(): Notification {
        val pendingIntent = PendingIntent.getActivity(
            this, 0,
            packageManager.getLaunchIntentForPackage(packageName),
            PendingIntent.FLAG_IMMUTABLE
        )
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("DroidWhisper")
            .setContentText("Floating mic widget is active")
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }
}
