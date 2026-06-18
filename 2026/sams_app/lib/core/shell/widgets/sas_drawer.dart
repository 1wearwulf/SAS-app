import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_avatar.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../core/constants/app_routes.dart';

class SasDrawer extends StatelessWidget {
  const SasDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final role = user?.role ?? 'student';
        
        return NavigationDrawer(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileAvatar(
                    name: user?.name ?? 'User',
                    radius: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Guest User',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'Not signed in',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            
            // Role-specific items
            if (role == 'student') ...[
              _buildNavItem(Icons.home, 'Dashboard', () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRoutes.studentDashboard);
              }),
              _buildNavItem(Icons.qr_code_scanner, 'Scan QR', () {
                Navigator.pop(context);
              }),
              _buildNavItem(Icons.bar_chart, 'My Attendance', () {
                Navigator.pop(context);
              }),
            ] else if (role == 'lecturer') ...[
              _buildNavItem(Icons.dashboard, 'Dashboard', () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRoutes.lecturerDashboard);
              }),
              _buildNavItem(Icons.play_circle, 'Active Session', () {
                Navigator.pop(context);
              }),
              _buildNavItem(Icons.edit, 'Send Activity', () {
                Navigator.pop(context);
              }),
            ] else if (role == 'admin') ...[
              _buildNavItem(Icons.shield, 'Audit Dashboard', () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, AppRoutes.adminAudit);
              }),
              _buildNavItem(Icons.report, 'Unit Reports', () {
                Navigator.pop(context);
              }),
            ],
            
            const Spacer(),
            
            const Divider(),
            _buildNavItem(Icons.settings, 'Settings', () {
              Navigator.pop(context);
            }),
            _buildNavItem(Icons.help, 'Help', () {
              Navigator.pop(context);
              _showHelpBottomSheet(context);
            }),
            _buildNavItem(Icons.logout, 'Log Out', () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            }),
          ],
        );
      },
    );
  }
  
  Widget _buildNavItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Log out of SAS?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(AuthSignOutRequested());
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
  
  void _showHelpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Help', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('• Tap "Start Session" to begin taking attendance'),
            SizedBox(height: 8),
            Text('• Students scan the QR code shown on your device'),
            SizedBox(height: 8),
            Text('• Export reports as PDF for your records'),
          ],
        ),
      ),
    );
  }
}
