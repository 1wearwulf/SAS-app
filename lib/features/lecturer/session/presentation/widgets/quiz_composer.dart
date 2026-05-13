import 'package:flutter/material.dart';

class QuizComposer extends StatefulWidget {
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
  State<QuizComposer> createState() => _QuizComposerState();
}

class _QuizComposerState extends State<QuizComposer> {
  final TextEditingController _titleController = TextEditingController();
  final List<Map<String, dynamic>> _questions = [];
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _addQuestion();
  }

  void _addQuestion() {
    setState(() {
      _questions.add({
        'text': '',
        'options': ['', '', '', ''],
        'correctIndex': null,
      });
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  Future<void> _sendQuiz() async {
    setState(() {
      _isSending = true;
      _errorMessage = null;
    });
    
    try {
      // Build quiz data
      final quizQuestions = _questions.map((q) => {
        'text': q['text'],
        'options': List<String>.from(q['options']),
        'correctIndex': q['correctIndex'],
      }).toList();
      
      // TODO: Send to Firebase
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quiz sent to ${widget.courseCode} students!'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onQuizSent();
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send quiz: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _titleController.text.isNotEmpty &&
        _questions.isNotEmpty &&
        _questions.every((q) => 
          q['text'].isNotEmpty && 
          q['options'].every((o) => o.isNotEmpty) &&
          q['correctIndex'] != null);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.quiz, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Send Quiz - ${widget.courseCode}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Quiz Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Quiz Title',
                hintText: 'e.g., Chapter 7 Quiz',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Questions List
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(_questions.length, (index) {
                    return _QuestionCard(
                      index: index,
                      question: _questions[index],
                      onUpdate: (updated) {
                        setState(() {
                          _questions[index] = updated;
                        });
                      },
                      onDelete: () => _removeQuestion(index),
                    );
                  }),
                ),
              ),
            ),
            
            // Add Question Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: OutlinedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Add Question'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  minimumSize: const Size(double.infinity, 40),
                ),
              ),
            ),
            
            // Error Message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            
            // Send Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isValid && !_isSending ? _sendQuiz : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Send Quiz →'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> question;
  final Function(Map<String, dynamic>) onUpdate;
  final VoidCallback onDelete;
  
  const _QuestionCard({
    required this.index,
    required this.question,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Q${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Type your question...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                onUpdate({...question, 'text': value});
              },
            ),
            const SizedBox(height: 12),
            ...List.generate(4, (optIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Radio<int>(
                      value: optIndex,
                      groupValue: question['correctIndex'],
                      onChanged: (value) {
                        onUpdate({...question, 'correctIndex': value});
                      },
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Option ${String.fromCharCode(65 + optIndex)}',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          final newOptions = List<String>.from(question['options']);
                          newOptions[optIndex] = value;
                          onUpdate({...question, 'options': newOptions});
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
