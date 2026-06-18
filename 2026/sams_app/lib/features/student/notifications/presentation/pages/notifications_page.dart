import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Session Started',
      message:
          'Dr. Ochieng has started a session for CS401 - Software Engineering',
      time: DateTime.now().subtract(const Duration(minutes: 15)),
      type: NotificationType.session,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Quiz Available',
      message: 'New quiz: Software Engineering Chapter 7 Quiz. Due in 2 hours.',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      type: NotificationType.quiz,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Attendance Alert',
      message:
          'Your attendance in CS401 is below 75%. Please attend upcoming sessions.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.alert,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Announcement',
      message: 'CAT for Database Systems has been moved to next week.',
      time: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.announcement,
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n.isRead = true;
                }
              });
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _NotificationTile(
            notification: notification,
            onTap: () {
              setState(() {
                notification.isRead = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening: ${notification.title}')),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: notification.isRead
            ? Colors.white
            : AppTheme.primary.withValues(alpha: 0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getTypeColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTypeIcon(),
                color: _getTypeColor(),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, h:mm a').format(notification.time),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (notification.type) {
      case NotificationType.session:
        return AppTheme.primary;
      case NotificationType.quiz:
        return AppTheme.warning;
      case NotificationType.alert:
        return AppTheme.error;
      case NotificationType.announcement:
        return AppTheme.secondary;
    }
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.session:
        return Icons.play_circle_outline;
      case NotificationType.quiz:
        return Icons.quiz_outlined;
      case NotificationType.alert:
        return Icons.warning_amber_outlined;
      case NotificationType.announcement:
        return Icons.announcement_outlined;
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType {
  session,
  quiz,
  alert,
  announcement,
}
