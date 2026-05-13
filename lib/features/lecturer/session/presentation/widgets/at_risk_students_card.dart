import 'package:flutter/material.dart';

class AtRiskStudentsCard extends StatelessWidget {
  final List<Map<String, dynamic>> students;

  const AtRiskStudentsCard({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Students Needing Attention',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          if (students.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('All students are on track')),
            )
          else
            ...students.map((student) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.red.withAlpha(25),
                        child: Text(student['initials'],
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          student['name'],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(student['course'],
                            style: const TextStyle(
                                fontSize: 10, color: Colors.blue)),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}
