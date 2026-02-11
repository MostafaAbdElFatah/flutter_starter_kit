import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/log.dart';
import '../../../features/auth/domain/repositories/auth_repository.dart';
import '../../../features/settings/domain/repositories/settings_repository.dart';
import 'local_notification_service.dart';

/// Background handler for FCM messages.
///
/// Must be a top-level function to be invoked by the platform isolate.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    debugPrint(
      '[FirebaseService] Background message received: ${message.messageId}',
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
class FirebaseService {
  FirebaseService({
    required AuthRepository authRepository,
    required SettingsRepository settingsRepository,
    required LocalNotificationService localNotificationService,
  })  : _localNotificationService = localNotificationService,
        _settingsRepository = settingsRepository,
        _authRepository = authRepository;

  late final FirebaseMessaging _messaging;
  final LocalNotificationService _localNotificationService;
  final SettingsRepository _settingsRepository;
  final AuthRepository _authRepository;

  bool _initialized = false;

  /// Initializes Firebase and configures messaging handlers.
  ///
  /// Call this once on app start (after DI is ready).
  @PostConstruct(preResolve: true)
  Future<void> init() async {
    if (_initialized) return;

    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _localNotificationService.init();
    await _requestPermissions();
    await _configureForegroundPresentation();

    _registerMessageListeners();
    _registerTokenRefreshListener();

    await _syncTokenOnAppStart();

    _initialized = true;
  }

  /// Explicitly syncs the token after a successful login.
  Future<void> syncTokenOnLogin() async {
    if (!_initialized) await init();

    try {
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) {
        Log.debug('No FCM token available on login.');
        return;
      }

      await _sendTokenToServer(token, reason: 'login');
    } catch (e, s) {
      Log.error('Failed to sync token on login: $e', error: e, stackTrace: s);
    }
  }

  // ---------------------------------------------------------------------------
  // Messaging setup
  // ---------------------------------------------------------------------------

  Future<void> _requestPermissions() async {
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
  }

  Future<void> _configureForegroundPresentation() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _registerMessageListeners() {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);
    _handleInitialMessage();
  }

  Future<void> _handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message == null) return;

    Log.debug('Initial message: ${message.messageId}');
    _handleNotificationOpen(message);
  }

  void _registerTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((token) async {
      Log.debug('FCM token refreshed: $token');
      await _sendTokenToServer(token, reason: 'refresh');
    });
  }

  Future<void> _syncTokenOnAppStart() async {
    try {
      final token = await _messaging.getToken();
      if (token == null || token.isEmpty) {
        Log.debug('No FCM token available on app start.');
        return;
      }

      await _sendTokenToServer(token, reason: 'app_open');
    } catch (e, s) {
      Log.error('Failed to sync token on app start:', error: e, stackTrace: s);
    }
  }

  Future<void> _sendTokenToServer(
    String token, {
    required String reason,
  }) async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (!isLoggedIn) {
        Log.debug('Skipping FCM token send ($reason) - user not logged in.');
        return;
      }

      //await _settingsRepository.saveFirebaseToken(token);
      Log.debug('FCM token sent to server ($reason).');
    } catch (e, s) {
      Log.error('Failed to send FCM token ($reason):', error: e, stackTrace: s);
    }
  }

  // ---------------------------------------------------------------------------
  // Message handlers
  // ---------------------------------------------------------------------------

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if(Platform.isIOS) return;
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if (title == null && body == null) {
      Log.debug('Foreground message without displayable content.');
      return;
    }

    await _localNotificationService.showNotification(
      id: _notificationId(message),
      title: title ?? 'UrPass',
      body: body ?? '',
    );
  }

  void _handleNotificationOpen(RemoteMessage message) {
    Log.debug('Notification opened: ${message.messageId}');
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
