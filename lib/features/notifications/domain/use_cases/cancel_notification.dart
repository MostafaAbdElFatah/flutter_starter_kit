import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/use_cases/usecase.dart';
import '../repository/notification_repository.dart';

/// Use case for canceling a single notification by its [id].
@lazySingleton
class CancelNotificationUseCase
    extends AsyncUseCase<NotificationRepository, void, int> {
  CancelNotificationUseCase(super.repository);

  @override
  Future<void> call(int params) {
    return repository.cancelNotification(params);
  }
}
