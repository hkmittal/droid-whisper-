/// Flutter-side wrapper for the native floating widget MethodChannel.
///
/// Provides typed methods for overlay permission management, widget
/// lifecycle control, and a stream of recording-request events that
/// come in from the native bubble button taps.
library;

import 'dart:async';
import 'package:flutter/services.dart';

/// Channel name must match [MainActivity.OVERLAY_CHANNEL] in Kotlin.
const _kChannelName = 'droid_whisper/overlay';

/// Wraps the [MethodChannel] used to communicate with [FloatingWidgetService].
///
/// Create one instance and share it (e.g. via a Riverpod provider).
class FloatingWidgetChannel {
  FloatingWidgetChannel() {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  final MethodChannel _channel = const MethodChannel(_kChannelName);

  // ── Stream controllers for events coming from native ───────────────────────
  final _startController = StreamController<void>.broadcast();
  final _stopController  = StreamController<void>.broadcast();
  final _permController  = StreamController<bool>.broadcast();

  /// Fires whenever the floating bubble button is tapped (start recording).
  Stream<void> get onWidgetStartRecording => _startController.stream;

  /// Fires whenever the floating overlay stop button is tapped.
  Stream<void> get onWidgetStopRecording => _stopController.stream;

  /// Fires after the system overlay-permission dialog closes.
  Stream<bool> get onOverlayPermissionResult => _permController.stream;

  // ── Native → Flutter handler ───────────────────────────────────────────────

  Future<void> _handleNativeCall(MethodCall call) async {
    switch (call.method) {
      case 'onWidgetStartRecording':
        _startController.add(null);
      case 'onWidgetStopRecording':
        _stopController.add(null);
      case 'onOverlayPermissionResult':
        final granted = (call.arguments as Map)['granted'] as bool? ?? false;
        _permController.add(granted);
      default:
        break;
    }
  }

  // ── Flutter → Native calls ─────────────────────────────────────────────────

  /// Returns whether the app currently holds the overlay (SYSTEM_ALERT_WINDOW) permission.
  Future<bool> hasOverlayPermission() async {
    final result = await _channel.invokeMethod<bool>('hasOverlayPermission');
    return result ?? false;
  }

  /// Opens the system Settings page so the user can grant overlay permission.
  Future<void> requestOverlayPermission() =>
      _channel.invokeMethod('requestOverlayPermission');

  /// Starts [FloatingWidgetService] and displays the floating bubble.
  ///
  /// Throws [PlatformException] with code `NO_PERMISSION` if overlay
  /// permission has not been granted.
  Future<void> startFloatingWidget() =>
      _channel.invokeMethod('startFloatingWidget');

  /// Stops [FloatingWidgetService] and removes the floating bubble.
  Future<void> stopFloatingWidget() =>
      _channel.invokeMethod('stopFloatingWidget');

  /// Notify native that Flutter recording has started → service shows full-screen overlay.
  Future<void> notifyRecordingStarted() =>
      _channel.invokeMethod('recordingStarted');

  /// Notify native that Flutter recording has stopped → service returns to bubble.
  Future<void> notifyRecordingStopped() =>
      _channel.invokeMethod('recordingStopped');

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  void dispose() {
    _startController.close();
    _stopController.close();
    _permController.close();
  }
}
