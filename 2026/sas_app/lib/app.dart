import 'package:flutter/material.dart';
import 'package:sas_app/features/student/dashboard/presentation/pages/student_dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAS App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const StudentDashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
