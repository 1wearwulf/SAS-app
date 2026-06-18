import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final announcements = [
      Announcement(
        id: '1',
        title: 'CAT Schedule Changes',
        message:
            'The Database Systems CAT has been moved to next week. Please check the updated schedule.',
        courseCode: 'CS302',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        isUrgent: true,
        author: 'Prof. Njoroge',
      ),
      Announcement(
        id: '2',
        title: 'Class Cancelled',
        message:
            'Today\'s Software Engineering class is cancelled due to a power outage.',
        courseCode: 'CS401',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isUrgent: true,
        author: 'Dr. Ochieng',
      ),
      Announcement(
        id: '3',
        title: 'Quiz Reminder',
        message:
            'Data Structures quiz on Trees will be available tomorrow at 8 AM.',
        courseCode: 'CS301',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isUrgent: false,
        author: 'Dr. Kamau',
      ),
      Announcement(
        id: '4',
        title: 'Project Submission',
        message:
            'Final project submissions are due on May 30th. Submit via the portal.',
        courseCode: 'CS403',
        date: DateTime.now().subtract(const Duration(days: 3)),
        isUrgent: false,
        author: 'Dr. Mwangi',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: announcements.length,
        itemBuilder: (context, index) =>
            _AnnouncementCard(announcement: announcements[index]),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    final isUrgent = announcement.isUrgent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? AppTheme.error : AppTheme.divider,
          width: isUrgent ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Reading: ${announcement.title}')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isUrgent
                            ? AppTheme.error.withValues(alpha: 0.1)
                            : AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isUrgent ? Icons.warning_amber : Icons.announcement,
                        size: 20,
                        color: isUrgent ? AppTheme.error : AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${announcement.courseCode} • ${announcement.author}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isUrgent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'URGENT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  announcement.message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _formatDate(announcement.date),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }
    return '${date.day}/${date.month}/${date.year}';
  }
}

class Announcement {
  final String id;
  final String title;
  final String message;
  final String courseCode;
  final DateTime date;
  final bool isUrgent;
  final String author;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.courseCode,
    required this.date,
    required this.isUrgent,
    required this.author,
  });
}
