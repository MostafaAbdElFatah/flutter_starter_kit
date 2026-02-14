import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

/// Use case for canceling **all** pending and displayed notifications.
@lazySingleton
class CancelAllNotificationsUseCase
    extends AsyncUseCase<NotificationRepository, void, NoParams> {
  CancelAllNotificationsUseCase(super.repository);

  @override
  Future<void> call(NoParams params) {
    return repository.cancelAllNotifications();
  }
}
