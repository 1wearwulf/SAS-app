import 'package:flutter/material.dart';

class ManualAttendanceMarker extends StatefulWidget {
  final String courseCode;
  final String courseName;
  final int totalStudents;
  final Function(Map<String, dynamic> student) onMarkAttendance;
  
  const ManualAttendanceMarker({
    super.key,
    required this.courseCode,
    required this.courseName,
    required this.totalStudents,
    required this.onMarkAttendance,
  });

  @override
  State<ManualAttendanceMarker> createState() => _ManualAttendanceMarkerState();
}

class _ManualAttendanceMarkerState extends State<ManualAttendanceMarker> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Mock students data
  final List<Map<String, dynamic>> _allStudents = [
    {"id": "CS/2021/0042", "name": "Amara Mwangi", "email": "amara@university.edu", "attended": false, "department": "CS"},
    {"id": "CS/2021/0043", "name": "Brian Odhiambo", "email": "brian@university.edu", "attended": false, "department": "CS"},
    {"id": "CS/2021/0044", "name": "Catherine Wanjiku", "email": "catherine@university.edu", "attended": false, "department": "CS"},
    {"id": "CS/2021/0045", "name": "David Omondi", "email": "david@university.edu", "attended": false, "department": "CS"},
    {"id": "CS/2021/0046", "name": "Esther Muthoni", "email": "esther@university.edu", "attended": false, "department": "CS"},
    {"id": "CS/2021/0047", "name": "Francis Kimani", "email": "francis@university.edu", "attended": true, "department": "CS"},
    {"id": "CS/2021/0048", "name": "Grace Atieno", "email": "grace@university.edu", "attended": true, "department": "CS"},
  ];

  List<Map<String, dynamic>> get _filteredStudents {
    if (_searchQuery.isEmpty) return _allStudents;
    return _allStudents.where((student) =>
      student['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
      student['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
      student['email'].toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  int get _presentCount => _allStudents.where((s) => s['attended']).length;

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
            onPressed: () {
              setState(() {
                for (var student in _allStudents) {
                  student['attended'] = true;
                  widget.onMarkAttendance(student);
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All students marked present'), backgroundColor: Colors.green),
              );
            },
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                        SizedBox(height: 4),
                        Text('Try a different search term', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${student['name']} marked ${student['attended'] ? "present" : "absent"}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
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
                const TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Justification for manual override (e.g., Student had technical issues)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Attendance saved: $_presentCount/${widget.totalStudents} students marked'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
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
