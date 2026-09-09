import 'package:flutter/foundation.dart';

/// Centralized logging utility — use Log.d / Log.e / Log.w instead of
/// debugPrint directly.
class Log {
  static void d(String tag, String message) {
    debugPrint('[$tag] $message');
  }

  static void e(String tag, String message) {
    debugPrint('[$tag] ERROR: $message');
  }

  static void w(String tag, String message) {
    debugPrint('[$tag] WARN: $message');
  }
}
