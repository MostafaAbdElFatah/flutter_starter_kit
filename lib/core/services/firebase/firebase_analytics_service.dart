import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';

import '../../utils/log.dart';
import 'firebase_service.dart';

/// Firebase Analytics wrapper.
///
/// Keeps analytics calls centralized and easy to mock/replace later.
@lazySingleton
class FirebaseAnalyticsService {
  FirebaseAnalyticsService({required FirebaseService firebaseService})
    : _firebaseService = firebaseService;

  final FirebaseService _firebaseService;
  bool _initialized = false;
  FirebaseAnalytics? _instance;

  FirebaseAnalytics get _analytics => _instance ?? FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> init() async {
    if (_initialized) return;

    await _firebaseService.init();
    _instance = FirebaseAnalytics.instance;
    _initialized = true;
  }

  Future<void> setEnabled(bool enabled) async {
    await init();
    try {
      await _analytics.setAnalyticsCollectionEnabled(enabled);
    } catch (error, stackTrace) {
      Log.error(
        '[Analytics setEnabled failed]',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> setUserId(String? userId) async {
    await init();
    try {
      await _analytics.setUserId(id: userId);
    } catch (error, stackTrace) {
      Log.error(
        '[Analytics setUserId failed]',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> setUserProperty({required String name, String? value}) async {
    await init();
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (error, stackTrace) {
      Log.error(
        '[Analytics setUserProperty failed]',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await init();
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (error, stackTrace) {
      Log.error(
        '[Analytics logEvent failed]',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await init();
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (error, stackTrace) {
      Log.error(
        '[Analytics logScreenView failed]',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
