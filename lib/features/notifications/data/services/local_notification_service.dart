import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

/// A service that encapsulates all `flutter_local_notifications` plugin logic.
///
/// This is the **only** class in the project that directly depends on the
/// notification plugin. Every other layer communicates through the
/// [NotificationRepository] abstraction — enforcing Dependency Inversion.
///
/// Updated to match the v20 API which uses all **named** parameters.
@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Whether the service has already been initialized.
  bool _initialized = false;

  // ──────────────────────────────────────────────────────────
  //  Initialization
  // ──────────────────────────────────────────────────────────

  /// Initializes the plugin and timezone data.
  ///
  /// Safe to call multiple times — will no-op after the first successful init.
  Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone database so zonedSchedule works correctly.
    tz_data.initializeTimeZones();

    // Android initialization settings.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // Default app icon
    );

    // iOS / macOS initialization settings — request no permissions at init
    // time so we can handle them explicitly via [requestPermissions].
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    // v20 API: `initialize` uses named `settings:` parameter.
    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  // ──────────────────────────────────────────────────────────
  //  Permissions
  // ──────────────────────────────────────────────────────────

  /// Requests notification permissions for both **Android 13+** and **iOS**.
  ///
  /// On Android < 13 this is a no-op (permissions are granted by default).
  /// On iOS it requests alert, badge, and sound permissions.
  Future<bool> requestPermissions() async {
    // ── Android 13+ (API 33) POST_NOTIFICATIONS ──
    final androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      if (granted != true) return false;
    }

    // ── iOS ──
    final iosPlugin =
        _plugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (granted != true) return false;
    }

    return true;
  }

  // ──────────────────────────────────────────────────────────
  //  Show Immediate Notification
  // ──────────────────────────────────────────────────────────

  /// Displays a notification **immediately**.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _ensureInitialized();

    const androidDetails = AndroidNotificationDetails(
      'urpass_local_channel', // Channel ID
      'Local Notifications', // Channel name
      channelDescription: 'UrPass local notification channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    // v20 API: `show` uses all named parameters.
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  // ──────────────────────────────────────────────────────────
  //  Schedule Notification
  // ──────────────────────────────────────────────────────────

  /// Schedules a notification for [scheduledDate].
  ///
  /// Uses `AndroidScheduleMode.exactAllowWhileIdle` so the alarm fires even
  /// if the device is in Doze mode. The notification will survive app restarts
  /// because the OS manages the scheduled alarm.
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _ensureInitialized();

    const androidDetails = AndroidNotificationDetails(
      'urpass_scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'UrPass scheduled notification channel',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    // Convert the plain DateTime to a TZDateTime in the device's local zone.
    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // v20 API: `zonedSchedule` uses all named parameters.
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzScheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  // ──────────────────────────────────────────────────────────
  //  Cancel
  // ──────────────────────────────────────────────────────────

  /// Cancels a single notification identified by [id].
  Future<void> cancelNotification(int id) => _plugin.cancel(id: id);

  /// Cancels **all** pending and displayed notifications.
  Future<void> cancelAllNotifications() => _plugin.cancelAll();

  // ──────────────────────────────────────────────────────────
  //  Helpers
  // ──────────────────────────────────────────────────────────

  /// Ensures the plugin is initialized before any operation.
  Future<void> _ensureInitialized() async {
    if (!_initialized) await init();
  }

  /// Callback for when the user taps a notification.
  ///
  /// Currently a no-op; expand as needed (e.g., deep-link navigation).
  void _onNotificationTap(NotificationResponse response) {
    // TODO: Handle notification tap — e.g., navigate to a specific screen.
  }
}
