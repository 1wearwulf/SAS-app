import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage({super.key});

  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  final List<Quiz> _quizzes = [
    Quiz(
      id: '1',
      title: 'Software Engineering - Chapter 7 Quiz',
      courseCode: 'CS401',
      dueDate: DateTime.now().add(const Duration(hours: 2)),
      questions: 10,
      timeLimit: 15,
      status: QuizStatus.pending,
    ),
    Quiz(
      id: '2',
      title: 'Data Structures - Trees & Graphs',
      courseCode: 'CS301',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      questions: 8,
      timeLimit: 20,
      status: QuizStatus.pending,
    ),
    Quiz(
      id: '3',
      title: 'Database Systems - SQL Basics',
      courseCode: 'CS302',
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      questions: 15,
      timeLimit: 30,
      score: 85,
      status: QuizStatus.completed,
    ),
    Quiz(
      id: '4',
      title: 'Networks - OSI Model',
      courseCode: 'CS403',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      questions: 12,
      timeLimit: 25,
      status: QuizStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pendingQuizzes =
        _quizzes.where((q) => q.status == QuizStatus.pending).toList();
    final completedQuizzes =
        _quizzes.where((q) => q.status == QuizStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quizzes'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
            label: const Text('Filter'),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Pending (${pendingQuizzes.length})'),
                Tab(text: 'Completed (${completedQuizzes.length})'),
              ],
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primary,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Pending Quizzes
                  pendingQuizzes.isEmpty
                      ? _buildEmptyState(
                          'No pending quizzes', Icons.quiz_outlined)
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: pendingQuizzes.length,
                          itemBuilder: (context, index) =>
                              _QuizCard(quiz: pendingQuizzes[index]),
                        ),
                  // Completed Quizzes
                  completedQuizzes.isEmpty
                      ? _buildEmptyState(
                          'No completed quizzes', Icons.check_circle_outline)
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: completedQuizzes.length,
                          itemBuilder: (context, index) =>
                              _QuizCard(quiz: completedQuizzes[index]),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppTheme.textSecondary),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  final Quiz quiz;

  const _QuizCard({required this.quiz});

  @override
  Widget build(BuildContext context) {
    final isCompleted = quiz.status == QuizStatus.completed;
    final isUrgent =
        quiz.dueDate.isBefore(DateTime.now().add(const Duration(hours: 24))) &&
            !isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent ? AppTheme.error : AppTheme.divider,
          width: isUrgent ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening ${quiz.title}...')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppTheme.secondary.withValues(alpha: 0.1)
                            : AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check_circle : Icons.quiz,
                        size: 20,
                        color:
                            isCompleted ? AppTheme.secondary : AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${quiz.courseCode} • ${quiz.questions} questions • ${quiz.timeLimit} min',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isUrgent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Urgent',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isCompleted)
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            _formatDueDate(quiz.dueDate),
                            style: TextStyle(
                              fontSize: 11,
                              color: isUrgent
                                  ? AppTheme.error
                                  : AppTheme.textSecondary,
                              fontWeight: isUrgent
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    if (isCompleted)
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 14, color: AppTheme.warning),
                          const SizedBox(width: 4),
                          Text(
                            'Score: ${quiz.score}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isCompleted ? Colors.white : AppTheme.primary,
                        foregroundColor:
                            isCompleted ? AppTheme.primary : Colors.white,
                        side: isCompleted
                            ? const BorderSide(color: AppTheme.primary)
                            : null,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(isCompleted ? 'Review' : 'Start Quiz'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    if (date.isBefore(DateTime.now())) {
      return 'Overdue';
    }
    final difference = date.difference(DateTime.now());
    if (difference.inHours < 24) {
      return 'Due in ${difference.inHours} hours';
    }
    return 'Due ${date.day}/${date.month}';
  }
}

class Quiz {
  final String id;
  final String title;
  final String courseCode;
  final DateTime dueDate;
  final int questions;
  final int timeLimit;
  final QuizStatus status;
  final int? score;

  Quiz({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.dueDate,
    required this.questions,
    required this.timeLimit,
    required this.status,
    this.score,
  });
}

enum QuizStatus {
  pending,
  completed,
}
