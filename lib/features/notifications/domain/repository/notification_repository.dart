import '../entities/notification_entity.dart';

/// Abstract repository contract for notification operations.
///
/// The domain layer depends on this abstraction — not on the concrete
/// implementation — enforcing Dependency Inversion (DIP).
///
/// The data layer provides the concrete [NotificationRepositoryImpl].
abstract class NotificationRepository {
  /// Shows a notification immediately.
  Future<void> showNotification(NotificationEntity notification);

  /// Schedules a notification for [notification.scheduledDate].
  ///
  /// The [scheduledDate] field **must not** be `null` when calling this method.
  Future<void> scheduleNotification(NotificationEntity notification);

  /// Cancels a single notification identified by [id].
  Future<void> cancelNotification(int id);

  /// Cancels **all** pending & shown notifications.
  Future<void> cancelAllNotifications();
}
