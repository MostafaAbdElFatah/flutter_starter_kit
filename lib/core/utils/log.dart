import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../di/di.dart' as di;

/// A utility class for logging messages.
/// This class provides a consistent way of logging messages throughout the application.
/// It uses the `logger` package to format and display logs.
/// Logs are only printed in debug mode.
///
/// Example:
/// ```dart
/// Log.info('This is an info message');
/// ```
class Log {
  // Private constructor to prevent instantiation.
  Log._();

  static final _logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
      //dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static bool get shouldDebug {
    final currentConfig = di.envConfigService.currentConfig;
    return kDebugMode && currentConfig.isDev;
  }

  /// Logs a trace message.
  /// Use this for fine-grained information, only printed in debug mode.
  /// Example:
  /// ```dart
  /// Log.trace('This is a trace message');
  /// ```
  static void trace(String message) {
    if (shouldDebug) _logger.d("[TRACE] $message");
  }

  /// Logs a debug message.
  /// Use this for debugging information, only printed in debug mode.
  /// Example:
  /// ```dart
  /// Log.debug('This is a debug message');
  /// ```
  static void debug(String message) {
    if (shouldDebug) _logger.d("[DEBUG] $message");
  }

  /// Logs an info message.
  /// Use this for informational messages, only printed in debug mode.
  /// Example:
  /// ```dart
  /// Log.info('This is an info message');
  /// ```
  static void info(String message) {
    if (shouldDebug) _logger.i("[INFO] $message");
  }

  /// Logs a warning message.
  /// Use this for warning messages, only printed in debug mode.
  /// Example:
  /// ```dart
  /// Log.warning('This is a warning message');
  /// ```
  static void warning(String message) {
    if (shouldDebug) _logger.w("[WARNING] $message");
  }

  /// Logs an error message.
  /// Use this for error messages, only printed in debug mode.
  /// Example:
  /// ```dart
  /// try {
  ///   // ...
  /// } catch (e, s) {
  ///   Log.error('An error occurred', error: e, stackTrace: s);
  /// }
  /// ```
  static void error(dynamic message, {Object? error, StackTrace? stackTrace}) {
    if (shouldDebug) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Logs a fatal error message.
  /// Use this for fatal error messages, only printed in debug mode.
  /// Example:
  /// ```dart
  /// try {
  ///   // ...
  /// } catch (e, s) {
  ///   Log.fatalError('A fatal error occurred', error: e, stackTrace: s);
  /// }
  /// ```
  static void fatalError(
    dynamic message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (shouldDebug) {
      _logger.f(message, error: error, stackTrace: stackTrace);
    }
  }
}
