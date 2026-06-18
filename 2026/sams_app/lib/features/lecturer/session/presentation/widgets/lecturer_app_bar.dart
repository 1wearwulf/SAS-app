import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LecturerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasActiveSession;
  final VoidCallback onRefresh;
  final VoidCallback onExport;
  final VoidCallback onProfile;
  final VoidCallback onSettings;
  final VoidCallback onAnalytics;
  
  const LecturerAppBar({
    super.key,
    required this.title,
    this.hasActiveSession = false,
    required this.onRefresh,
    required this.onExport,
    required this.onProfile,
    required this.onSettings,
    required this.onAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          if (hasActiveSession)
            Container(
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0.5,
      centerTitle: false,
      actions: [
        // Refresh button
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: onRefresh,
          tooltip: 'Refresh',
        ),
        // Export button
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: onExport,
          tooltip: 'Export Report',
        ),
        // Analytics button
        IconButton(
          icon: const Icon(Icons.analytics),
          onPressed: onAnalytics,
          tooltip: 'Analytics Dashboard',
        ),
        // Profile menu
        PopupMenuButton<String>(
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFF1D4ED8),
            child: Text(
              'DO',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                onProfile();
                break;
              case 'settings':
                onSettings();
                break;
              case 'logout':
                context.go('/login');
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person, size: 20),
                  SizedBox(width: 12),
                  Text('My Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 20),
                  SizedBox(width: 12),
                  Text('Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, size: 20, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Log Out', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
