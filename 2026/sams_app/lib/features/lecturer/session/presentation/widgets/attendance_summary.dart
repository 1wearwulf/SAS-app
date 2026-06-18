import 'package:flutter/material.dart';

class AttendanceSummary extends StatelessWidget {
  final int presentCount;
  final int totalCount;
  final int flaggedCount;
  final double averageRisk;
  
  const AttendanceSummary({
    super.key,
    required this.presentCount,
    required this.totalCount,
    required this.flaggedCount,
    required this.averageRisk,
  });

  @override
  Widget build(BuildContext context) {
    final attendanceRate = totalCount > 0 ? (presentCount / totalCount * 100) : 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _SummaryItem(
                label: 'Present',
                value: '$presentCount',
                color: Colors.green,
                icon: Icons.check_circle,
              ),
              _SummaryItem(
                label: 'Flagged',
                value: '$flaggedCount',
                color: Colors.orange,
                icon: Icons.warning_amber,
              ),
              _SummaryItem(
                label: 'Absent',
                value: '${totalCount - presentCount}',
                color: Colors.red,
                icon: Icons.cancel,
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: attendanceRate / 100,
            backgroundColor: Colors.grey.shade200,
            color: attendanceRate >= 75 ? Colors.green : Colors.orange,
            
          ),
          const SizedBox(height: 8),
          Text(
            'Attendance Rate: ${attendanceRate.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              color: attendanceRate >= 75 ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
