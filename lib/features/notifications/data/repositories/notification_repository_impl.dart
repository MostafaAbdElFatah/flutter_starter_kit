import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../services/local_notification_service.dart';

/// Concrete implementation of [NotificationRepository].
///
/// Delegates all work to [LocalNotificationService] and wraps any exceptions
/// with [Failure.handle] — consistent with the rest of the project's
/// repository implementations (e.g., [HomeRepositoryImpl]).
@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final LocalNotificationService _service;

  NotificationRepositoryImpl({
    required LocalNotificationService service,
  }) : _service = service;

  @override
  Future<void> showNotification(NotificationEntity notification) async {
    try {
      await _service.showNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
      );
    } catch (e) {
      throw Failure.handle(e);
    }
  }

  @override
  Future<void> scheduleNotification(NotificationEntity notification) async {
    try {
      await _service.scheduleNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        scheduledDate: notification.scheduledDate!,
      );
    } catch (e) {
      throw Failure.handle(e);
    }
  }

  @override
  Future<void> cancelNotification(int id) async {
    try {
      await _service.cancelNotification(id);
    } catch (e) {
      throw Failure.handle(e);
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    try {
      await _service.cancelAllNotifications();
    } catch (e) {
      throw Failure.handle(e);
    }
  }
}
