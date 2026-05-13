class QuizModel {
  final String id;
  final String title;
  final String courseCode;
  final String courseName;
  final List<QuizQuestion> questions;
  final int timeLimitPerQuestion;
  final DateTime sentAt;
  final DateTime expiresAt;
  final String status; // 'active', 'expired', 'completed'
  
  QuizModel({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.courseName,
    required this.questions,
    required this.timeLimitPerQuestion,
    required this.sentAt,
    required this.expiresAt,
    this.status = 'active',
  });
  
  int get totalDuration => questions.length * timeLimitPerQuestion;
}

class QuizQuestion {
  final String text;
  final List<String> options;
  final int correctOptionIndex;
  
  QuizQuestion({
    required this.text,
    required this.options,
    required this.correctOptionIndex,
  });
}
