import 'dart:io';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../utils/log.dart';
import '../notification/local_notification_service.dart';
import 'firebase_analytics_service.dart';
import 'firebase_crashlytics_service.dart';
import 'firebase_service.dart';

typedef FCMTokenSyncHandler =
    Future<void> Function(String token, String reason);

/// Background handler for FCM messages.
///
/// Must be a top-level function to be invoked by the platform isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  if (kDebugMode) {
    debugPrint(
      '[FirebaseMessageService] Background message received: ${message.messageId}',
    );
  }
}

/// A service that wires Firebase Messaging into the app lifecycle.
///
/// Responsibilities:
/// - Initialize Firebase.
/// - Request notification permissions.
/// - Listen to foreground/background/terminated messages.
/// - Sync the FCM token with the backend when needed.
@lazySingleton
class FirebaseMessageService {
  FirebaseMessageService({
    required FirebaseService firebaseService,
    required FirebaseAnalyticsService analyticsService,
    required FirebaseCrashlyticsService crashlyticsService,
    required AuthRepository authRepository,
    required LocalNotificationService localNotificationService,
  }) : _localNotificationService = localNotificationService,
       _authRepository = authRepository,
       _firebaseService = firebaseService,
       _analyticsService = analyticsService,
       _crashlyticsService = crashlyticsService;

  late final FirebaseMessaging _messaging;
  final LocalNotificationService _localNotificationService;
  final AuthRepository _authRepository;
  final FirebaseService _firebaseService;
  final FirebaseAnalyticsService _analyticsService;
  final FirebaseCrashlyticsService _crashlyticsService;

  bool _initialized = true;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openedAppSubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  FCMTokenSyncHandler? _tokenSyncHandler;

  /// Initializes Firebase and configures messaging handlers.
  ///
  /// Call this once on app start (after DI is ready).
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    if (_initialized) return;

    await _firebaseService.init();
    await _analyticsService.init();
    await _crashlyticsService.init();

    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _localNotificationService.init();
    await _requestPermissions();
    await _configureForegroundPresentation();

    _registerMessageListeners();
    _registerTokenRefreshListener();

    await _syncToken(reason: 'app_open');

    _initialized = true;
  }

  /// Optional app-level callback for syncing token with backend.
  void setTokenSyncHandler(FCMTokenSyncHandler handler) {
    _tokenSyncHandler = handler;
  }

  void clearTokenSyncHandler() {
    _tokenSyncHandler = null;
  }

  Future<String?> getToken() async {
    if (!_initialized) await init();
    return _messaging.getToken();
  }

  /// Explicitly syncs the token after a successful login.
  Future<void> syncTokenOnLogin() async {
    if (!_initialized) await init();
    await _syncToken(reason: 'login');
  }

  /// Explicitly dispose stream subscriptions when needed.
  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _openedAppSubscription?.cancel();
    await _tokenRefreshSubscription?.cancel();
    _foregroundSubscription = null;
    _openedAppSubscription = null;
    _tokenRefreshSubscription = null;
    _initialized = false;
  }

  // ---------------------------------------------------------------------------
  // Messaging setup
  // ---------------------------------------------------------------------------

  Future<void> _requestPermissions() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final localGranted = await _localNotificationService.requestPermissions();

      Log.debug(
        'Push permission: ${settings.authorizationStatus}, '
        'local: $localGranted',
      );

      await _analyticsService.logEvent(
        name: 'push_permission_result',
        parameters: {
          'authorization_status': settings.authorizationStatus.name,
          'local_permission_granted': localGranted,
        },
      );
    } catch (error, stackTrace) {
      Log.error(
        'Failed to request push permissions.',
        error: error,
        stackTrace: stackTrace,
      );
      await _crashlyticsService.recordError(
        error,
        stackTrace,
        reason: 'messaging_request_permissions',
      );
    }
  }

  Future<void> _configureForegroundPresentation() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _registerMessageListeners() {
    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      unawaited(_handleForegroundMessage(message));
    });

    _openedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) {
      unawaited(_handleNotificationOpen(message));
    });

    unawaited(_handleInitialMessage());
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message == null) return;

    Log.debug('Initial notification message: ${message.messageId}');
    await _handleNotificationOpen(message);
  }

  void _registerTokenRefreshListener() {
    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen((token) async {
      await _syncTokenValue(token, reason: 'refresh');
    });
  }

  Future<void> _syncToken({required String reason}) async {
    try {
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) {
        Log.debug('No FCM token available ($reason).');
        return;
      }

      await _syncTokenValue(token, reason: reason);
    } catch (error, stackTrace) {
      Log.error(
        'Failed to sync FCM token ($reason).',
        error: error,
        stackTrace: stackTrace,
      );
      await _crashlyticsService.recordError(
        error,
        stackTrace,
        reason: 'messaging_sync_token_$reason',
      );
    }
  }

  Future<void> _syncTokenValue(String token, {required String reason}) async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (!isLoggedIn) {
        Log.debug('Skipping FCM token send ($reason) - user not logged in.');
        return;
      }

      final handler = _tokenSyncHandler;
      if (handler == null) {
        Log.debug('No FCM token sync handler registered ($reason).');
        return;
      }

      await handler(token, reason);
      await _analyticsService.logEvent(
        name: 'fcm_token_synced',
        parameters: {'reason': reason},
      );
    } catch (error, stackTrace) {
      Log.error(
        'Failed to send FCM token ($reason).',
        error: error,
        stackTrace: stackTrace,
      );
      await _crashlyticsService.recordError(
        error,
        stackTrace,
        reason: 'messaging_send_token_$reason',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Message handlers
  // ---------------------------------------------------------------------------

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (!kIsWeb && Platform.isIOS) return;

    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if (title == null && body == null) {
      Log.debug('Foreground message without displayable content.');
      return;
    }

    try {
      await _localNotificationService.showNotification(
        id: _notificationId(message),
        title: title ?? 'UrPass',
        body: body ?? '',
      );
      await _analyticsService.logEvent(
        name: 'push_foreground_received',
        parameters: {'has_data': message.data.isNotEmpty},
      );
    } catch (error, stackTrace) {
      Log.error(
        'Failed to display foreground push notification.',
        error: error,
        stackTrace: stackTrace,
      );
      await _crashlyticsService.recordError(
        error,
        stackTrace,
        reason: 'messaging_foreground_display',
      );
    }
  }

  Future<void> _handleNotificationOpen(RemoteMessage message) async {
    Log.debug('Notification opened: ${message.messageId}');
    await _analyticsService.logEvent(
      name: 'push_notification_opened',
      parameters: {'has_data': message.data.isNotEmpty},
    );
    // TODO: Add navigation/deep-link handling as needed.
  }

  int _notificationId(RemoteMessage message) {
    final id = message.messageId;
    if (id == null) {
      return DateTime.now().millisecondsSinceEpoch.remainder(100000);
    }
    return id.hashCode;
  }
}
