import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/student/dashboard/presentation/pages/student_dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Attendance System',
      theme: AppTheme.lightTheme,
      home: const StudentDashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
