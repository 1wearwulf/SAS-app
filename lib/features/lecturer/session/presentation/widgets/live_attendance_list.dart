import 'package:flutter/material.dart';

class LiveAttendanceList extends StatefulWidget {
  final String courseCode;
  final int totalStudents;
  
  const LiveAttendanceList({
    super.key,
    required this.courseCode,
    required this.totalStudents,
  });

  @override
  State<LiveAttendanceList> createState() => _LiveAttendanceListState();
}

class _LiveAttendanceListState extends State<LiveAttendanceList> {
  // Mock live attendance data - would come from Firestore stream
  List<Map<String, dynamic>> _attendedStudents = [
    {"id": "CS/2021/0042", "name": "Amara Mwangi", "time": "10:02 AM", "method": "QR", "risk": "safe"},
    {"id": "CS/2021/0043", "name": "Brian Odhiambo", "time": "10:05 AM", "method": "Manual", "risk": "safe"},
    {"id": "CS/2021/0046", "name": "Esther Muthoni", "time": "10:08 AM", "method": "QR", "risk": "warning"},
    {"id": "CS/2021/0047", "name": "Francis Kimani", "time": "10:10 AM", "method": "QR", "risk": "safe"},
  ];

  final ScrollController _scrollController = ScrollController();

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
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Live Attendance (${_attendedStudents.length}/${widget.totalStudents})',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.green),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Table headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 40),
                const Expanded(
                  child: Text('Student', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey)),
                ),
                SizedBox(width: 60, child: Text('Time', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey))),
                SizedBox(width: 70, child: Text('Method', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey))),
                SizedBox(width: 60, child: Text('Risk', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey))),
              ],
            ),
          ),
          const Divider(height: 1),
          
          // Scrollable list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _attendedStudents.length,
              itemBuilder: (context, index) {
                final student = _attendedStudents[index];
                return _AttendanceRow(student: student);
              },
            ),
          ),
          
          // Footer with auto-scroll toggle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Auto-scroll: ON',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Text(
                  'Last update: just now',
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  final Map<String, dynamic> student;
  
  const _AttendanceRow({required this.student});

  @override
  Widget build(BuildContext context) {
    final riskColor = student['risk'] == 'safe' ? Colors.green : Colors.orange;
    final methodColor = student['method'] == 'QR' ? Colors.blue : Colors.purple;
    
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.blue.withAlpha(25),
              child: Text(
                student['name'].split(' ').map((s) => s[0]).join(''),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.blue),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'],
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    student['id'],
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                student['time'],
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              ),
            ),
            SizedBox(
              width: 70,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: methodColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  student['method'],
                  style: TextStyle(fontSize: 10, color: methodColor, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: riskColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  student['risk'].toUpperCase(),
                  style: TextStyle(fontSize: 10, color: riskColor, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
