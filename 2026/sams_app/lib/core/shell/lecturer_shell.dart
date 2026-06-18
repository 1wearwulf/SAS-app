import 'package:flutter/material.dart';
import 'widgets/sas_app_bar.dart';
import 'widgets/sas_drawer.dart';

class LecturerShell extends StatelessWidget {
  final Widget child;
  
  const LecturerShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SasDrawer(),
      appBar: const SasAppBar(
        title: 'Lecturer Portal',
        showDrawerToggle: true,
      ),
      body: child,
    );
  }
}
