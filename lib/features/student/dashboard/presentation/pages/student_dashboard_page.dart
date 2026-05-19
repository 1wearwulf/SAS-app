import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/enrollment_cubit.dart';
import '../../../attendance/domain/entities/active_session.dart';
import '../../../attendance/presentation/pages/qr_scanner_page.dart';
import '../../../attendance/presentation/pages/access_code_entry_page.dart';
import '../../../attendance/data/services/student_session_service.dart';
import '../../domain/entities/enrollment.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  late final StudentSessionService _sessionService;
  bool _attendanceMarked = false;
  String? _lastMethod;

  @override
  void initState() {
    super.initState();
    _sessionService = StudentSessionService();
    _sessionService.startMockSession();
  }

  @override
  void dispose() {
    _sessionService.dispose();
    super.dispose();
  }

  void _markAttendance(String method) {
    setState(() {
      _attendanceMarked = true;
      _lastMethod = method;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('✓ Attendance marked via $method!'),
          backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = _sessionService.currentSession;

    return BlocProvider(
      create: (context) => EnrollmentCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('Student Portal'),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Stack(
              children: [
                IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {}),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle)),
                ),
              ],
            ),
          ],
        ),
        drawer: _buildDrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _GreetingRow(name: "Amara"),
              const SizedBox(height: 20),
              const _StatsRow(),
              const SizedBox(height: 20),
              if (_attendanceMarked)
                _buildSuccessCard()
              else if (session != null && session.isActive)
                _buildActiveSessionCard(session)
              else
                _buildNoSessionCard(),
              const SizedBox(height: 20),
              BlocBuilder<EnrollmentCubit, EnrollmentState>(
                builder: (context, state) {
                  if (state is EnrollmentLoading)
                    return const Center(child: CircularProgressIndicator());
                  if (state is EnrollmentLoaded)
                    return _MyCoursesCard(enrollments: state.enrollments);
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Color(0xFF1D4ED8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Text('AM',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                const SizedBox(height: 12),
                const Text('Amara Mwangi',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('CS/2021/0042',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          ),
          ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              tileColor: Colors.blue.shade50,
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Schedule'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Attendance History'),
              onTap: () => Navigator.pop(context)),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.quiz),
              title: const Text('Quizzes'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.pop(context)),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out', style: TextStyle(color: Colors.red)),
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard(ActiveSession session) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)]),
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white.withAlpha(38),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.play_circle_filled,
                        color: Colors.white, size: 28)),
                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      const Text('Active Session',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text('${session.courseCode} - ${session.courseName}',
                          style: TextStyle(color: Colors.white.withAlpha(230))),
                    ])),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('LIVE',
                        style: TextStyle(color: Colors.white, fontSize: 11))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(Icons.person, session.lecturer),
                const SizedBox(width: 12),
                _buildInfoChip(Icons.location_on, session.room),
                const SizedBox(width: 12),
                _buildInfoChip(
                    Icons.access_time, session.formattedTimeRemaining),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRScannerPage(
                                onSuccess: () => _markAttendance('QR')))),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan QR'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1D4ED8),
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccessCodeEntryPage(
                                onSuccess: () =>
                                    _markAttendance('Access Code')))),
                    icon: const Icon(Icons.keyboard),
                    label: const Text('Enter Code'),
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white.withAlpha(38),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Expanded(
                child: Text(label,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const Text('Attendance Recorded!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('Marked present via $_lastMethod',
                    style: const TextStyle(color: Colors.white70)),
              ])),
        ],
      ),
    );
  }

  Widget _buildNoSessionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('No active session',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 4),
            Text('Wait for your lecturer to start a session',
                style: TextStyle(color: Colors.grey)),
          ]),
          Icon(Icons.snooze, size: 40, color: Colors.grey),
        ],
      ),
    );
  }
}

// Rest of the widgets (same as before)
class _GreetingRow extends StatelessWidget {
  final String name;
  const _GreetingRow({required this.name});
  @override
  Widget build(BuildContext context) => Column(
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
  Widget build(BuildContext context) => const Row(
        children: [
          _StatCard(
              label: 'Overall Attendance',
              value: '74%',
              trend: '−3% this week',
              trendColor: Color(0xFFDC2626)),
          SizedBox(width: 12),
          _StatCard(
              label: 'Engagement Score',
              value: '0.61',
              trend: '+0.04 this week',
              trendColor: Color(0xFF16A34A)),
          SizedBox(width: 12),
          _StatCard(
              label: 'Avg Quiz Score',
              value: '68%',
              trend: 'Across 4 courses',
              trendColor: Color(0xFF64748B)),
          SizedBox(width: 12),
          _StatCard(
              label: 'Sessions Today',
              value: '3',
              trend: 'Today\'s schedule',
              trendColor: Color(0xFF64748B)),
        ],
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
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(trend, style: TextStyle(fontSize: 10, color: trendColor)),
          ]),
        ),
      );
}

class _MyCoursesCard extends StatelessWidget {
  final List<Enrollment> enrollments;
  const _MyCoursesCard({required this.enrollments});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('My Courses',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Active courses',
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFF64748B)))
                  ])),
          const Divider(),
          Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: enrollments
                      .map((e) => _CourseCard(enrollment: e))
                      .toList())),
        ]),
      );
}

class _CourseCard extends StatelessWidget {
  final Enrollment enrollment;
  const _CourseCard({required this.enrollment});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Opening ${enrollment.unitName} details...'))),
        child: Container(
          width: (MediaQuery.of(context).size.width - 60) / 2,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            Row(children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: enrollment.isDeferred
                          ? const Color(0xFFD97706).withAlpha(25)
                          : const Color(0xFF16A34A).withAlpha(25),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(enrollment.isDeferred ? 'Deferred' : 'Active',
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: enrollment.isDeferred
                              ? const Color(0xFFD97706)
                              : const Color(0xFF16A34A)))),
              const Spacer(),
              Text('Year ${enrollment.year}',
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
            ]),
          ]),
        ),
      );
}
