import 'package:flutter/material.dart';

class BroadcastNotification extends StatelessWidget {
  final String courseCode;
  final String courseName;
  
  const BroadcastNotification({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Broadcast to $courseCode'),
      content: const Text('Send announcement to students...'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Send')),
      ],
    );
  }
}
