part of 'notification_cubit.dart';

/// Base class for all notification-related states.
///
/// Follows the project convention of using [Equatable] for value-based
/// comparison (see `home_state.dart` for reference).
abstract class NotificationState extends Equatable {
  const NotificationState();
}

/// The initial idle state before any notification action has been triggered.
class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

/// Indicates that a notification action is in progress.
class NotificationLoading extends NotificationState {
  @override
  List<Object> get props => [];
}

/// Emitted when a notification action completes successfully.
class NotificationSuccess extends NotificationState {
  /// A human-readable message describing what succeeded.
  final String message;
  const NotificationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

/// Emitted when a notification action fails.
class NotificationError extends NotificationState {
  /// A human-readable error description.
  final String message;
  const NotificationError(this.message);

  @override
  List<Object> get props => [message];
}
