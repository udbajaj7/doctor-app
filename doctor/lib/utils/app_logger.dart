import 'package:flutter/foundation.dart';

/// Lightweight logging helper.
///
/// Logs are emitted only in debug builds so that no diagnostic output (and,
/// importantly, no sensitive data) is written in release builds. Never pass
/// secrets such as passwords, OTPs, auth headers or full request/response
/// bodies to this function.
void logDebug(Object? message) {
  if (kDebugMode) {
    debugPrint(message?.toString());
  }
}
