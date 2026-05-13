import 'package:flutter/material.dart';
import '../../domain/entities/session_config.dart';

class StartSessionModal extends StatefulWidget {
  final Function(SessionConfig) onStartSession;
  
  const StartSessionModal({super.key, required this.onStartSession});

  @override
  State<StartSessionModal> createState() => _StartSessionModalState();
}

class _StartSessionModalState extends State<StartSessionModal> {
  String? _selectedCourse;
  int _durationMinutes = 60;
  
  final List<Map<String, dynamic>> _courses = [
    {"code": "CS401", "name": "Software Engineering", "room": "E202", "students": 44},
    {"code": "CS301", "name": "Data Structures", "room": "LH4", "students": 52},
    {"code": "CS302", "name": "Database Systems", "room": "LH2", "students": 48},
    {"code": "CS403", "name": "Networks & Security", "room": "E101", "students": 43},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Start New Session', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCourse,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                hint: const Text('Select Course'),
                items: _courses.map((course) {
                  return DropdownMenuItem<String>(
                    value: course['code'],
                    child: Text('${course['code']} - ${course['name']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCourse = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Duration (minutes)'),
              const SizedBox(height: 8),
              Slider(
                value: _durationMinutes.toDouble(),
                min: 30,
                max: 120,
                divisions: 6,
                label: '$_durationMinutes min',
                onChanged: (value) {
                  setState(() {
                    _durationMinutes = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedCourse != null
                          ? () {
                              final course = _courses.firstWhere((c) => c['code'] == _selectedCourse);
                              widget.onStartSession(SessionConfig(
                                courseCode: course['code'],
                                courseName: course['name'],
                                room: course['room'],
                                durationMinutes: _durationMinutes,
                                geofenceRadius: 0,
                                enableGeofencing: false,
                              ));
                              Navigator.pop(context);
                            }
                          : null,
                      child: const Text('Start'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
