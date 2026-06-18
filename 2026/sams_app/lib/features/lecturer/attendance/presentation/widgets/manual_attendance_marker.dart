import 'package:flutter/material.dart';

class ManualAttendanceMarker extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final VoidCallback onAttendanceMarked;
  
  const ManualAttendanceMarker({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.onAttendanceMarked,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Attendance - $courseCode'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: const Center(
        child: Text('Manual attendance marking feature coming soon...'),
      ),
    );
  }
}
