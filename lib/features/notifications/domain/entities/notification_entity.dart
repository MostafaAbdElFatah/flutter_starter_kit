import 'package:equatable/equatable.dart';

/// A domain entity representing a local notification.
///
/// This entity is intentionally free of any Flutter or plugin imports,
/// keeping the domain layer pure and testable.
///
/// [scheduledDate] is optional — when provided the notification is scheduled
/// for that point in time; when `null`, the notification is shown immediately.
class NotificationEntity extends Equatable {
  /// Unique identifier used to cancel or update this notification.
  final int id;

  /// The notification title displayed to the user.
  final String title;

  /// The notification body / description.
  final String body;

  /// The date & time at which the notification should be shown.
  ///
  /// When `null`, the notification is treated as an **immediate** notification.
  final DateTime? scheduledDate;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.scheduledDate,
  });

  @override
  List<Object?> get props => [id, title, body, scheduledDate];
}
