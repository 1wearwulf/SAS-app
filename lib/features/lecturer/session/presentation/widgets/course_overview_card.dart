import 'package:flutter/material.dart';

class CourseOverviewCard extends StatelessWidget {
  final List<Map<String, dynamic>> courses;
  
  const CourseOverviewCard({super.key, required this.courses});

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
            child: Text('My Courses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ...courses.map((course) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(course['code'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(course['name'])),
                    Text('${course['students']} students', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 6,
                        child: LinearProgressIndicator(
                          value: course['attendance'] / 100,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${course['attendance']}%', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
