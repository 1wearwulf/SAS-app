import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final Color? backgroundColor;
  
  const ProfileAvatar({
    super.key,
    required this.name,
    this.radius = 30,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final color = backgroundColor ?? Colors.blue;
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withAlpha(51),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
  
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
