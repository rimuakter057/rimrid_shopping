import 'package:flutter/foundation.dart';

/// Formatted console logger for API requests, responses, and provider state events.
class AppLogger {
  AppLogger._();

  static void logApiRequest({required String method, required String url}) {
    if (kDebugMode) {
      debugPrint('╔════════════════════ [API REQUEST] ════════════════════');
      debugPrint('║ METHOD : $method');
      debugPrint('║ URL    : $url');
      debugPrint('╚═══════════════════════════════════════════════════════');
    }
  }

  static void logApiResponse({required int statusCode, required String url, required String summary}) {
    if (kDebugMode) {
      debugPrint('╔════════════════════ [API RESPONSE] ═══════════════════');
      debugPrint('║ STATUS  : $statusCode ${statusCode == 200 ? '✅ OK' : '❌ ERROR'}');
      debugPrint('║ URL     : $url');
      debugPrint('║ SUMMARY : $summary');
      debugPrint('╚═══════════════════════════════════════════════════════');
    }
  }

  static void logApiError({required String url, required Object error}) {
    if (kDebugMode) {
      debugPrint('╔════════════════════ [API NETWORK ERROR] ══════════════');
      debugPrint('║ URL   : $url');
      debugPrint('║ ERROR : $error');
      debugPrint('╚═══════════════════════════════════════════════════════');
    }
  }

  static void logEvent(String category, String message) {
    if (kDebugMode) {
      debugPrint('[$category] $message');
    }
  }
}
