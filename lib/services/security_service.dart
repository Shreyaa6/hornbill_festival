import 'package:flutter/services.dart';

class SecurityService {
  static const MethodChannel _channel = MethodChannel('hornbill.festival/security');

  /// Prevents taking screenshots and screen recordings on Android (FLAG_SECURE)
  /// and iOS (secure UITextField layer protection).
  static Future<void> enableSecure() async {
    try {
      await _channel.invokeMethod('enableSecure');
    } catch (_) {}
  }

  /// Restores normal screen capture outside the protected view.
  static Future<void> disableSecure() async {
    try {
      await _channel.invokeMethod('disableSecure');
    } catch (_) {}
  }
}
