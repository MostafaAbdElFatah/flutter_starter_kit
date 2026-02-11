import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../cubit/notification_cubit.dart';

/// A demo page showcasing all local notification features.
///
/// Provides buttons for:
/// 1. Showing an immediate notification
/// 2. Scheduling a notification (10 seconds from now)
/// 3. Canceling a specific notification by ID
/// 4. Canceling all notifications
///
/// Uses [BlocProvider] to provide the cubit and [BlocListener] to display
/// snackbar feedback on state changes.
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => get<NotificationCubit>(),
      child: const _NotificationPageBody(),
    );
  }
}

class _NotificationPageBody extends StatelessWidget {
  const _NotificationPageBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications Demo')),
      body: BlocListener<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
          } else if (state is NotificationError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // ── 1. Show Immediate Notification ──
              _ActionButton(
                label: '🔔 Show Notification',
                onPressed: () {
                  NotificationCubit.of(context).showNotification(
                    id: 0,
                    title: 'Hello from UrPass!',
                    body: 'This is an immediate notification.',
                  );
                },
              ),

              const SizedBox(height: 16),

              // ── 2. Schedule Notification (10 seconds from now) ──
              _ActionButton(
                label: '⏰ Schedule Notification (10s)',
                onPressed: () {
                  final scheduledTime = DateTime.now().add(
                    const Duration(seconds: 10),
                  );
                  NotificationCubit.of(context).scheduleNotification(
                    id: 1,
                    title: 'Scheduled Reminder',
                    body: 'This notification was scheduled 10 seconds ago.',
                    scheduledDate: scheduledTime,
                  );
                },
              ),

              const SizedBox(height: 16),

              // ── 3. Cancel Notification by ID ──
              _ActionButton(
                label: '❌ Cancel Notification #0',
                onPressed: () {
                  NotificationCubit.of(context).cancelNotification(0);
                },
              ),

              const SizedBox(height: 16),

              // ── 4. Cancel All Notifications ──
              _ActionButton(
                label: '🗑️ Cancel All Notifications',
                onPressed: () {
                  NotificationCubit.of(context).cancelAllNotifications();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A styled action button used in the notification demo page.
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}
