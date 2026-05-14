import 'package:flutter/material.dart';

class ManualAttendanceMarker extends StatefulWidget {
  final String courseCode;
  final String courseName;
  final int totalStudents;
  final Function(Map<String, dynamic> student) onMarkAttendance;
  final Function(List<Map<String, dynamic>> students) onBulkMarkAttendance;
  
  const ManualAttendanceMarker({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.totalStudents,
    required this.onMarkAttendance,
    required this.onBulkMarkAttendance,
  });

  @override
  State<ManualAttendanceMarker> createState() => _ManualAttendanceMarkerState();
}

class _ManualAttendanceMarkerState extends State<ManualAttendanceMarker> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _justification;
  final TextEditingController _justificationController = TextEditingController();
  
  // Generate realistic student list based on totalStudents
  late List<Map<String, dynamic>> _students;
  
  @override
  void initState() {
    super.initState();
    _generateStudentList();
  }
  
  void _generateStudentList() {
    _students = List.generate(widget.totalStudents, (index) {
      final studentNum = 1000 + index;
      return {
        "id": "CS/2021/${studentNum.toString().padLeft(4, '0')}",
        "name": _getRandomName(index),
        "email": "student$studentNum@university.edu",
        "attended": false,
        "department": "CS",
      };
    });
  }
  
  String _getRandomName(int index) {
    final firstNames = ["Amara", "Brian", "Catherine", "David", "Esther", "Francis", "Grace", "Henry", "Ivy", "James", "Kelly", "Lewis", "Mary", "Nathan", "Olivia"];
    final lastNames = ["Mwangi", "Odhiambo", "Wanjiku", "Omondi", "Muthoni", "Kimani", "Atieno", "Kamau", "Njeri", "Otieno", "Wambui", "Kipchoge", "Achieng", "Ochieng", "Wanjala"];
    return "${firstNames[index % firstNames.length]} ${lastNames[index % lastNames.length]}";
  }

  List<Map<String, dynamic>> get _filteredStudents {
    if (_searchQuery.isEmpty) return _students;
    return _students.where((student) =>
      student['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
      student['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
      student['email'].toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  int get _presentCount => _students.where((s) => s['attended']).length;

  void _markAllPresent() {
    setState(() {
      for (var student in _students) {
        if (!student['attended']) {
          student['attended'] = true;
          widget.onMarkAttendance(student);
        }
      }
    });
    widget.onBulkMarkAttendance(_students.where((s) => s['attended']).toList());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All students marked present'), backgroundColor: Colors.green),
    );
  }

  void _saveAttendance() {
    if (_justificationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a justification for manual attendance'), backgroundColor: Colors.orange),
      );
      return;
    }
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance saved: $_presentCount/${widget.totalStudents} students marked'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Attendance - ${widget.courseCode}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _markAllPresent,
            icon: const Icon(Icons.done_all, size: 20),
            label: const Text('Mark All'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(25),
              border: Border(bottom: BorderSide(color: Colors.green.withAlpha(51))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(label: 'Total', value: '${widget.totalStudents}', color: Colors.blue),
                _StatChip(label: 'Present', value: '$_presentCount', color: Colors.green),
                _StatChip(label: 'Absent', value: '${widget.totalStudents - _presentCount}', color: Colors.red),
              ],
            ),
          ),
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by Registration Number, Name, or Email',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Student list
          Expanded(
            child: _filteredStudents.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_off, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('No students found'),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _filteredStudents.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      return _StudentTile(
                        student: student,
                        onToggle: () {
                          setState(() {
                            student['attended'] = !student['attended'];
                            widget.onMarkAttendance(student);
                          });
                        },
                      );
                    },
                  ),
          ),
          
          // Footer with justification
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _justificationController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Justification for manual override (e.g., Student had technical issues)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    errorText: _justification != null && _justificationController.text.isEmpty
                        ? 'Justification is required'
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
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
                        onPressed: _saveAttendance,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(13),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final Map<String, dynamic> student;
  final VoidCallback onToggle;
  
  const _StudentTile({
    required this.student,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: student['attended'] 
            ? Colors.green 
            : Colors.grey.shade300,
        child: Text(
          student['name'].split(' ').map((s) => s[0]).join(''),
          style: TextStyle(
            color: student['attended'] ? Colors.white : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      title: Text(
        student['name'],
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            student['id'],
            style: const TextStyle(fontSize: 11),
          ),
          Text(
            student['email'],
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: student['attended'] 
              ? Colors.green.withAlpha(25) 
              : Colors.red.withAlpha(25),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextButton(
          onPressed: onToggle,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            minimumSize: Size.zero,
          ),
          child: Text(
            student['attended'] ? 'Present' : 'Absent',
            style: TextStyle(
              color: student['attended'] ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
      onTap: onToggle,
    );
  }
}
