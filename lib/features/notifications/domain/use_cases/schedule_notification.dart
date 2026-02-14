import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/use_cases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repository/notification_repository.dart';

/// Use case for scheduling a notification at a future date & time.
///
/// The caller must ensure [NotificationEntity.scheduledDate] is not null.
@lazySingleton
class ScheduleNotificationUseCase
    extends AsyncUseCase<NotificationRepository, void, NotificationEntity> {
  ScheduleNotificationUseCase(super.repository);

  @override
  Future<void> call(NotificationEntity params) {
    assert(
      params.scheduledDate != null,
      'scheduledDate must not be null for scheduling',
    );
    return repository.scheduleNotification(params);
  }
}
