import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/enrollment_cubit.dart';
import '../widgets/active_session_card.dart';
import '../../domain/entities/enrollment.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final activeSession = {
      "courseCode": "CS401",
      "courseName": "Software Engineering",
      "lecturer": "Dr. Ochieng",
      "room": "E202",
      "qrExpiresAt": "10:45 AM",
    };

    return BlocProvider(
      create: (context) => EnrollmentCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _GreetingRow(name: "Amara"),
                const SizedBox(height: 20),
                const _StatsRow(),
                const SizedBox(height: 20),
                ActiveSessionCard(
                  session: activeSession,
                  onAttendanceMarked: (marked, method) {
                    print('Attendance marked via $method');
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<EnrollmentCubit, EnrollmentState>(
                  builder: (context, state) {
                    if (state is EnrollmentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is EnrollmentLoaded) {
                      return _MyCoursesCard(enrollments: state.enrollments);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Rest of the components...
class _GreetingRow extends StatelessWidget {
  final String name;
  const _GreetingRow({required this.name});
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Good ${_getTimeOfDay()}, $name 👋',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(_getFormattedDate(),
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        ],
      );
  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    return '${_getDayName(now.weekday)}, ${_getMonthName(now.month)} ${now.day} · Week 8';
  }

  String _getDayName(int w) => const [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ][w - 1];
  String _getMonthName(int m) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m - 1];
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _StatCard(
                  label: 'Overall Attendance',
                  value: '74%',
                  trend: '−3% this week',
                  trendColor: Color(0xFFDC2626)),
              _StatCard(
                  label: 'Engagement Score',
                  value: '0.61',
                  trend: '+0.04 this week',
                  trendColor: Color(0xFF16A34A)),
              _StatCard(
                  label: 'Avg Quiz Score',
                  value: '68%',
                  trend: 'Across 4 courses',
                  trendColor: Color(0xFF64748B)),
              _StatCard(
                  label: 'Sessions Today',
                  value: '3',
                  trend: 'Today\'s schedule',
                  trendColor: Color(0xFF64748B)),
            ],
          );
        },
      );
}

class _StatCard extends StatelessWidget {
  final String label, value, trend;
  final Color trendColor;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.trend,
      required this.trendColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 80) / 4,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(trend, style: TextStyle(fontSize: 10, color: trendColor)),
          ],
        ),
      ),
    );
  }
}

class _MyCoursesCard extends StatelessWidget {
  final List<Enrollment> enrollments;
  const _MyCoursesCard({required this.enrollments});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('My Courses',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children:
                  enrollments.map((e) => _CourseCard(enrollment: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final Enrollment enrollment;
  const _CourseCard({required this.enrollment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showCourseDetail(context, enrollment),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: (MediaQuery.of(context).size.width - 80) / 2,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(enrollment.unitCode,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8))),
            const SizedBox(height: 4),
            Text(enrollment.unitName,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                maxLines: 1),
            const SizedBox(height: 4),
            Text(enrollment.lecturer,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                maxLines: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: enrollment.isDeferred
                        ? const Color(0xFFD97706).withAlpha(25)
                        : const Color(0xFF16A34A).withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    enrollment.isDeferred ? 'Deferred' : 'Active',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: enrollment.isDeferred
                          ? const Color(0xFFD97706)
                          : const Color(0xFF16A34A),
                    ),
                  ),
                ),
                const Spacer(),
                Text('Year ${enrollment.year}',
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF94A3B8))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCourseDetail(BuildContext context, Enrollment enrollment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D4ED8).withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(enrollment.unitCode,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(enrollment.unitName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(enrollment.lecturer,
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            _InfoRow(
                label: 'Status',
                value: enrollment.isDeferred ? 'Deferred' : 'Active'),
            _InfoRow(label: 'Year', value: 'Year ${enrollment.year}'),
            _InfoRow(label: 'Semester', value: enrollment.semester),
            _InfoRow(label: 'Attendance', value: '74%'),
            _InfoRow(label: 'Next Session', value: 'Today at 10:00 AM'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(color: Color(0xFF64748B)))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
