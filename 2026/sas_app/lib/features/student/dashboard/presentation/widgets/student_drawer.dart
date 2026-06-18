import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_event.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import '../../../../../../core/theme/app_theme.dart';

class StudentDrawer extends StatelessWidget {
  const StudentDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state;
    final userName = user is AuthAuthenticated ? user.user.name : 'Student';
    final userEmail =
        user is AuthAuthenticated ? user.user.email : 'student@university.edu';

    return Drawer(
      child: Column(
        children: [
          // Header with gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.school, size: 32, color: AppTheme.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/student/dashboard');
                  },
                ),
                _DrawerItem(
                  icon: Icons.qr_code_scanner,
                  title: 'Scan QR',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/student/scan');
                  },
                ),
                _DrawerItem(
                  icon: Icons.history,
                  title: 'Attendance History',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/student/history');
                  },
                ),
                _DrawerItem(
                  icon: Icons.calendar_today,
                  title: 'Schedule',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/student/schedule');
                  },
                ),
                const Divider(),
                _DrawerItem(
                  icon: Icons.quiz,
                  title: 'Quizzes',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/student/quizzes');
                  },
                ),
                _DrawerItem(
                  icon: Icons.announcement,
                  title: 'Announcements',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/student/announcements');
                  },
                ),
                _DrawerItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/student/notifications');
                  },
                ),
                const Divider(),
                _DrawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/student/profile');
                  },
                ),
                _DrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/student/settings');
                  },
                ),
                _DrawerItem(
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    _showHelpDialog(context);
                  },
                ),
                const Divider(),
                _DrawerItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  iconColor: AppTheme.error,
                  textColor: AppTheme.error,
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutRequested());
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Scan QR code to mark attendance'),
            SizedBox(height: 8),
            Text('• Enter access code if QR fails'),
            SizedBox(height: 8),
            Text('• Check your attendance history'),
            SizedBox(height: 8),
            Text('• Contact support: support@sas.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppTheme.textSecondary),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
