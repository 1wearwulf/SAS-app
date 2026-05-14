import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/start_session_modal.dart';
import '../widgets/course_overview_card.dart';
import '../widgets/at_risk_students_card.dart';
import '../widgets/qr_modal.dart';
import '../widgets/access_code_panel.dart';
import '../widgets/manual_attendance_marker.dart';
import '../widgets/live_attendance_list.dart';
import '../../domain/entities/session_config.dart';

class LecturerDashboardPage extends StatefulWidget {
  const LecturerDashboardPage({super.key});

  @override
  State<LecturerDashboardPage> createState() => _LecturerDashboardPageState();
}

class _LecturerDashboardPageState extends State<LecturerDashboardPage> {
  bool _hasActiveSession = false;
  Map<String, dynamic>? _activeSession;
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;

  int _presentCount = 0;
  int _totalStudents = 44;

  final List<Map<String, dynamic>> _courses = [
    {
      "code": "CS401",
      "name": "Software Engineering",
      "students": 44,
      "attendance": 65,
      "critical": 3,
      "warnings": 7
    },
    {
      "code": "CS301",
      "name": "Data Structures",
      "students": 52,
      "attendance": 84,
      "critical": 0,
      "warnings": 2
    },
    {
      "code": "CS302",
      "name": "Database Systems",
      "students": 48,
      "attendance": 79,
      "critical": 1,
      "warnings": 4
    },
    {
      "code": "CS403",
      "name": "Networks & Security",
      "students": 43,
      "attendance": 91,
      "critical": 0,
      "warnings": 0
    },
  ];

  final List<Map<String, dynamic>> _atRiskStudents = [
    {
      "name": "Brian Otieno",
      "reg": "CS/2021/0018",
      "initials": "BO",
      "course": "CS401",
      "r_score": 0.71,
      "level": "CRITICAL"
    },
    {
      "name": "Faith Wambua",
      "reg": "CS/2021/0033",
      "initials": "FW",
      "course": "CS401",
      "r_score": 0.63,
      "level": "CRITICAL"
    },
    {
      "name": "James Njoroge",
      "reg": "CS/2021/0055",
      "initials": "JN",
      "course": "CS302",
      "r_score": 0.58,
      "level": "WARNING"
    },
  ];

  final List<Map<String, dynamic>> _todaySchedule = [
    {
      "time": "8:00 AM",
      "course": "CS301",
      "name": "Data Structures",
      "room": "LH4",
      "status": "done"
    },
    {
      "time": "10:00 AM",
      "course": "CS401",
      "name": "Software Engineering",
      "room": "E202",
      "status": "live"
    },
    {
      "time": "2:00 PM",
      "course": "CS302",
      "name": "Database Systems",
      "room": "LH2",
      "status": "scheduled"
    },
  ];

  void _startSession(SessionConfig config) {
    final expiresAt =
        DateTime.now().add(Duration(minutes: config.durationMinutes));
    _timeRemaining = Duration(minutes: config.durationMinutes);
    _presentCount = 0;
    _totalStudents =
        _courses.firstWhere((c) => c['code'] == config.courseCode)['students'];

    final manualCode =
        "${config.courseCode}_${DateTime.now().millisecondsSinceEpoch}"
            .substring(0, 6)
            .toUpperCase();

    setState(() {
      _hasActiveSession = true;
      _activeSession = {
        "courseCode": config.courseCode,
        "courseName": config.courseName,
        "room": config.room,
        "durationMinutes": config.durationMinutes,
        "totalStudents": _totalStudents,
        "startedAt": DateTime.now(),
        "expiresAt": expiresAt,
        "qrCode": manualCode,
      };
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining.inSeconds <= 1) {
          _timer?.cancel();
          _hasActiveSession = false;
          _activeSession = null;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Session ended automatically'),
                backgroundColor: Colors.orange),
          );
        } else {
          _timeRemaining = _timeRemaining - const Duration(seconds: 1);
        }
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Session started for ${config.courseName}!'),
          backgroundColor: Colors.green),
    );
  }

  void _endSession() {
    _timer?.cancel();
    setState(() {
      _hasActiveSession = false;
      _activeSession = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Session ended'), backgroundColor: Colors.red),
    );
  }

  void _refreshAttendance() {
    setState(() {
      _presentCount = (_presentCount + 3).clamp(0, _totalStudents);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Attendance refreshed'),
          duration: Duration(seconds: 1)),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Session Control'),
            if (_hasActiveSession)
              Container(
                margin: const EdgeInsets.only(left: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('LIVE',
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          if (_hasActiveSession)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshAttendance,
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Welcome Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('Welcome Dr. Ochieng',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ),
          const SizedBox(height: 20),

          // Stats Row
          const Row(
            children: [
              _StatCard(
                  label: 'Total Students',
                  value: '187',
                  trend: '+3',
                  color: Colors.blue),
              SizedBox(width: 12),
              _StatCard(
                  label: 'Active Courses',
                  value: '4',
                  trend: 'This sem',
                  color: Colors.green),
              SizedBox(width: 12),
              _StatCard(
                  label: 'Avg Attendance',
                  value: '76%',
                  trend: '+5%',
                  color: Colors.orange),
              SizedBox(width: 12),
              _StatCard(
                  label: 'Quizzes Sent',
                  value: '23',
                  trend: 'Total',
                  color: Colors.purple),
            ],
          ),
          const SizedBox(height: 20),

          // Active Session or Start Button
          if (_hasActiveSession && _activeSession != null)
            _buildActiveSessionCard()
          else
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      StartSessionModal(onStartSession: _startSession),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Start Session',
                  style: TextStyle(color: Colors.white)),
            ),

          const SizedBox(height: 24),

          // Today's Schedule Card
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Today\'s Schedule',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('View all →',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.blue)),
                        ])),
                const Divider(),
                ..._todaySchedule
                    .map((session) => _ScheduleRow(session: session)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Two column layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: CourseOverviewCard(courses: _courses)),
              const SizedBox(width: 20),
              Expanded(
                  flex: 4,
                  child: AtRiskStudentsCard(students: _atRiskStudents)),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildActiveSessionCard() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Colors.green, Colors.greenAccent]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_activeSession!['courseCode'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                      Text(_activeSession!['courseName'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text('Room: ${_activeSession!['room']}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Text(_formatDuration(_timeRemaining),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const Text('Remaining',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _timeRemaining.inSeconds /
                    (_activeSession!['durationMinutes'] * 60),
                backgroundColor: Colors.white.withAlpha(51),
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _AttendanceStat(
                        label: 'Present',
                        count: _presentCount,
                        color: Colors.white),
                    _AttendanceStat(
                        label: 'Absent',
                        count: _totalStudents - _presentCount,
                        color: Colors.white70),
                    _AttendanceStat(
                        label: 'Total',
                        count: _totalStudents,
                        color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => QRModal(
                            qrData: _activeSession!['qrCode'],
                            accessCode: _activeSession!['qrCode'],
                            courseCode: _activeSession!['courseCode'],
                            courseName: _activeSession!['courseName'],
                            room: _activeSession!['room'],
                            expiresAt: _activeSession!['expiresAt'],
                          ),
                        );
                      },
                      icon: const Icon(Icons.qr_code),
                      label: const Text('QR Code'),
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (context) => AccessCodePanel(
                            accessCode: _activeSession!['qrCode'],
                            courseCode: _activeSession!['courseCode'],
                            expiresAt: _activeSession!['expiresAt'],
                            onCodeValidated: (code) {
                              print('Code validated: $code');
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.keyboard),
                      label: const Text('Access Code'),
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.85,
                            child: ManualAttendanceMarker(
                              courseCode: _activeSession!['courseCode'],
                              courseName: _activeSession!['courseName'],
                              totalStudents: _activeSession!['totalStudents'],
                              onMarkAttendance: (student) {
                                setState(() {
                                  _presentCount = (_presentCount + 1)
                                      .clamp(0, _totalStudents);
                                });
                              },
                              onBulkMarkAttendance: (students) {
                                setState(() {
                                  _presentCount = students.length;
                                });
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Manual'),
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _endSession,
                      icon: const Icon(Icons.stop),
                      label: const Text('End'),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: LiveAttendanceList(
            courseCode: _activeSession!['courseCode'],
            totalStudents: _activeSession!['totalStudents'],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, trend;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.trend,
      required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(trend, style: TextStyle(fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }
}

class _AttendanceStat extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _AttendanceStat(
      {required this.label, required this.count, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$count',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: TextStyle(fontSize: 11, color: color.withAlpha(179))),
      ],
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final Map<String, dynamic> session;
  const _ScheduleRow({required this.session});
  @override
  Widget build(BuildContext context) {
    final colors = {
      'done': Colors.green,
      'live': Colors.blue,
      'scheduled': Colors.grey
    };
    final labels = {'done': 'Done', 'live': 'Live', 'scheduled': 'Scheduled'};
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
              width: 60,
              child: Text(session['time'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey))),
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  color: colors[session['status']], shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${session['course']} - ${session['name']}',
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(session['room'],
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: colors[session['status']]!.withAlpha(25),
                borderRadius: BorderRadius.circular(20)),
            child: Text(labels[session['status']]!,
                style:
                    TextStyle(fontSize: 11, color: colors[session['status']])),
          ),
        ],
      ),
    );
  }
}
