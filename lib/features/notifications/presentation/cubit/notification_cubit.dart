import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/infrastructure/usecases/usecase.dart';
import '../../../../core/infrastructure/cubits/base_cubit.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/cancel_all_notifications.dart';
import '../../domain/usecases/cancel_notification.dart';
import '../../domain/usecases/schedule_notification.dart';
import '../../domain/usecases/show_notification.dart';

part 'notification_state.dart';

/// Cubit that orchestrates notification actions through use cases.
///
/// The cubit **never** calls plugin code directly — it only communicates
/// through domain-layer use cases, keeping the presentation layer decoupled.
///
/// Mirrors the project's [HomeCubit] pattern with loading → success / error
/// state transitions.
@injectable
class NotificationCubit extends BaseCubit<NotificationState> {
  final ShowNotificationUseCase _showNotificationUseCase;
  final ScheduleNotificationUseCase _scheduleNotificationUseCase;
  final CancelNotificationUseCase _cancelNotificationUseCase;
  final CancelAllNotificationsUseCase _cancelAllNotificationsUseCase;

  NotificationCubit({
    required ShowNotificationUseCase showNotificationUseCase,
    required ScheduleNotificationUseCase scheduleNotificationUseCase,
    required CancelNotificationUseCase cancelNotificationUseCase,
    required CancelAllNotificationsUseCase cancelAllNotificationsUseCase,
  })  : _showNotificationUseCase = showNotificationUseCase,
        _scheduleNotificationUseCase = scheduleNotificationUseCase,
        _cancelNotificationUseCase = cancelNotificationUseCase,
        _cancelAllNotificationsUseCase = cancelAllNotificationsUseCase,
        super(NotificationInitial());

  /// A static helper to retrieve the cubit from the widget tree.
  static NotificationCubit of(BuildContext context, {bool listen = false}) =>
      BaseCubit.of(context, listen: listen);

  // ──────────────────────────────────────────────────────────
  //  Actions
  // ──────────────────────────────────────────────────────────

  /// Shows an immediate notification.
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    emit(NotificationLoading());
    try {
      await _showNotificationUseCase(
        NotificationEntity(id: id, title: title, body: body),
      );
      emit(const NotificationSuccess('Notification shown successfully'));
    } catch (error) {
      emit(NotificationError(error.toString()));
    }
  }

  /// Schedules a notification for [scheduledDate].
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    emit(NotificationLoading());
    try {
      await _scheduleNotificationUseCase(
        NotificationEntity(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
        ),
      );
      emit(const NotificationSuccess('Notification scheduled successfully'));
    } catch (error) {
      emit(NotificationError(error.toString()));
    }
  }

  /// Cancels a single notification by [id].
  Future<void> cancelNotification(int id) async {
    emit(NotificationLoading());
    try {
      await _cancelNotificationUseCase(id);
      emit(NotificationSuccess('Notification #$id canceled'));
    } catch (error) {
      emit(NotificationError(error.toString()));
    }
  }

  /// Cancels all pending and displayed notifications.
  Future<void> cancelAllNotifications() async {
    emit(NotificationLoading());
    try {
      await _cancelAllNotificationsUseCase(const NoParams());
      emit(const NotificationSuccess('All notifications canceled'));
    } catch (error) {
      emit(NotificationError(error.toString()));
    }
  }
}
