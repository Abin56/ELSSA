import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void logError(
    Object error, {
    StackTrace? stackTrace,
    String? code,
    String? context,
  }) {
    if (!kDebugMode) return;

    debugPrint('┌─ AppException${context != null ? ' [$context]' : ''}');
    debugPrint('│ error: $error');
    if (code != null) debugPrint('│ code: $code');
    if (stackTrace != null) debugPrint('│ stackTrace:\n$stackTrace');
    debugPrint('└─');
  }
}
