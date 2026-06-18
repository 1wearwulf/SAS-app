import 'package:flutter/material.dart';

class QuizComposer extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final VoidCallback onQuizSent;
  
  const QuizComposer({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.onQuizSent,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create Quiz - $courseCode'),
      content: const Text('Quiz composer coming soon...'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onQuizSent();
          },
          child: const Text('Send Quiz'),
        ),
      ],
    );
  }
}
