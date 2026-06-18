import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  final List<AttendanceRecord> _records = [
    AttendanceRecord(
      courseCode: 'CS401',
      courseName: 'Software Engineering',
      date: DateTime.now(),
      status: 'present',
      time: '10:05 AM',
      method: 'QR',
    ),
    AttendanceRecord(
      courseCode: 'CS301',
      courseName: 'Data Structures',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'present',
      time: '8:02 AM',
      method: 'QR',
    ),
    AttendanceRecord(
      courseCode: 'CS401',
      courseName: 'Software Engineering',
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: 'absent',
      time: '-',
      method: '-',
    ),
    AttendanceRecord(
      courseCode: 'CS302',
      courseName: 'Database Systems',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'present',
      time: '2:30 PM',
      method: 'Manual',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Attendance',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '74%',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 50,
                  color: Colors.white24,
                ),
                const Expanded(
                  child: Column(
                    children: [
                      Text('Present', style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 4),
                      Text(
                        '42',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Column(
                    children: [
                      Text('Absent', style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 4),
                      Text(
                        '15',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Recent Records',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('Filter'),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _records.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final record = _records[index];
                return _HistoryCard(record: record);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final AttendanceRecord record;

  const _HistoryCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final isPresent = record.status == 'present';
    final statusColor = isPresent ? AppTheme.secondary : AppTheme.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPresent ? Icons.check_circle : Icons.cancel,
              color: statusColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.courseCode} - ${record.courseName}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(record.date)} • ${record.time}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  'Method: ${record.method}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              record.status.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class AttendanceRecord {
  final String courseCode;
  final String courseName;
  final DateTime date;
  final String status;
  final String time;
  final String method;

  AttendanceRecord({
    required this.courseCode,
    required this.courseName,
    required this.date,
    required this.status,
    required this.time,
    required this.method,
  });
}
