import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../utils/log.dart';
import 'firebase_service.dart';

/// Firebase Crashlytics wrapper.
///
/// Exposes a small API for error reporting while keeping plugin details
/// out of feature code.
@lazySingleton
class FirebaseCrashlyticsService {
  FirebaseCrashlyticsService({required FirebaseService firebaseService})
    : _firebaseService = firebaseService;

  bool _initialized = false;
  bool _globalHandlersBound = false;
  FirebaseCrashlytics? _instance;
  final FirebaseService _firebaseService;

  FirebaseCrashlytics get _crashlytics =>
      _instance ?? FirebaseCrashlytics.instance;

  Future<void> init({bool collectInDebug = false}) async {
    if (_initialized) return;

    await _firebaseService.init();
    _instance = FirebaseCrashlytics.instance;

    final enabled = kReleaseMode || collectInDebug;
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);

    _initialized = true;
    bindGlobalErrorHandlers();
  }

  Future<void> setUserId(String? userId) async {
    await init();
    try {
      await _crashlytics.setUserIdentifier(userId ?? '');
    } catch (error, stackTrace) {
      Log.error(
        '[Crashlytics setUserId failed]',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> setCustomKey(String key, Object value) async {
    await init();
    try {
      await _crashlytics.setCustomKey(key, value);
    } catch (error, stackTrace) {
      Log.error(
        '[Crashlytics setCustomKey failed]',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> log(String message) async {
    await init();
    try {
      await _crashlytics.log(message);
    } catch (error, stackTrace) {
      Log.error(
        '[Crashlytics log failed]',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await init();
    try {
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    } catch (recordingError, recordingStackTrace) {
      Log.error(
        '[Crashlytics recordError failed]',
        error: recordingError,
        stackTrace: recordingStackTrace,
      );
    }
  }

  /// Binds global Flutter error handlers to Crashlytics.
  ///
  /// Safe to call multiple times.
  void bindGlobalErrorHandlers() {
    if (_globalHandlersBound) return;

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      unawaited(
        recordError(
          details.exception,
          details.stack ?? StackTrace.current,
          reason: 'flutter_error',
          fatal: false,
        ),
      );
    };

    PlatformDispatcher.instance.onError =
        (Object error, StackTrace stackTrace) {
          unawaited(
            recordError(
              error,
              stackTrace,
              reason: 'platform_dispatcher_error',
              fatal: true,
            ),
          );
          return true;
        };

    _globalHandlersBound = true;
  }
}
