import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/analytics/presentation/pages/analytics_page.dart';

class StudentShell extends StatelessWidget {
  final Widget child;
  
  const StudentShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const _Drawer(),
      appBar: AppBar(
        title: const Text('Student Portal'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
            tooltip: 'Search',
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => _showNotificationsDialog(context),
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: child,
    );
  }
  
  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Search'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search courses, materials...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Popular searches:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  Chip(label: Text('CS401')),
                  Chip(label: Text('Software Engineering')),
                  Chip(label: Text('Attendance')),
                  Chip(label: Text('Quizzes')),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
  
  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Notifications'),
        content: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.warning_amber, color: Colors.red),
                title: const Text('Risk Alert: CS401 attendance below 75%'),
                subtitle: const Text('2 hours ago'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/analytics');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.quiz, color: Colors.orange),
                title: const Text('Quiz Due: Software Engineering Ch.7'),
                subtitle: const Text('Closes in 2 hours'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening quiz...')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.event, color: Colors.blue),
                title: const Text('CAT Reminder: Database Systems'),
                subtitle: const Text('Tomorrow at 9:00 AM'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Profile Header - Clickable
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1D4ED8),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text('AM', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Amara Mwangi', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          const Text('CS/2021/0042', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('View Profile', style: TextStyle(color: Colors.white, fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Navigation Items
            _buildDrawerItem(
              context,
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () {
                Navigator.pop(context);
                context.go('/student/dashboard');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.calendar_today,
              title: 'Schedule',
              onTap: () {
                Navigator.pop(context);
                _showComingSoon(context, 'Schedule');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.menu_book,
              title: 'My Courses',
              onTap: () {
                Navigator.pop(context);
                _showComingSoon(context, 'My Courses');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.analytics,
              title: 'Analytics',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AnalyticsPage()),
                );
              },
            ),
            const Divider(),
            _buildDrawerItem(
              context,
              icon: Icons.quiz,
              title: 'Quizzes',
              onTap: () {
                Navigator.pop(context);
                _showComingSoon(context, 'Quizzes');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.assignment,
              title: 'Assignments',
              onTap: () {
                Navigator.pop(context);
                _showComingSoon(context, 'Assignments');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.folder,
              title: 'Materials',
              onTap: () {
                Navigator.pop(context);
                _showComingSoon(context, 'Materials');
              },
            ),
            const Divider(),
            _buildDrawerItem(
              context,
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                _showComingSoon(context, 'Settings');
              },
            ),
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: 'Log Out',
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDrawerItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF64748B)),
      title: Text(title),
      onTap: onTap,
    );
  }
  
  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
