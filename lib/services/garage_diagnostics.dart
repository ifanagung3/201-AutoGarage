import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Opt-in diagnostics. Callers must supply counters/types only, never customer
/// values, document IDs, auth UIDs, credentials, or raw exception messages.
class GarageDiagnostics {
  static const enabled = kDebugMode &&
      bool.fromEnvironment('GARAGE_DIAGNOSTICS', defaultValue: false);

  static void log(String event, [Map<String, Object?> fields = const {}]) {
    if (!enabled) return;
    debugPrint('[GARAGE_DIAG] ${jsonEncode({'event': event, ...fields})}');
  }

  static T measure<T>(String operation, T Function() action) {
    if (!enabled) return action();
    final watch = Stopwatch()..start();
    log('$operation.start');
    try {
      final result = action();
      log('$operation.success', {'elapsedUs': watch.elapsedMicroseconds});
      return result;
    } catch (error) {
      log('$operation.error', {
        'elapsedUs': watch.elapsedMicroseconds,
        'type': error.runtimeType.toString(),
      });
      rethrow;
    }
  }
}
