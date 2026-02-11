import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/domain/usecases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

/// Use case for displaying an immediate notification.
///
/// Follows the project's [AsyncUseCase] convention:
///   R = repository type, T = return type, P = parameter type.
@lazySingleton
class ShowNotificationUseCase
    extends AsyncUseCase<NotificationRepository, void, NotificationEntity> {
  ShowNotificationUseCase(super.repository);

  @override
  Future<void> call(NotificationEntity params) {
    return repository.showNotification(params);
  }
}
