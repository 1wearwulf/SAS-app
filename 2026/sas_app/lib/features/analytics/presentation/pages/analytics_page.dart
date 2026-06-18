import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Attendance Trend Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Attendance Trend',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Last 7 weeks',
                        style: TextStyle(color: Color(0xFF64748B))),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const weeks = [
                                    'W3',
                                    'W4',
                                    'W5',
                                    'W6',
                                    'W7',
                                    'W8',
                                    'W9'
                                  ];
                                  if (value.toInt() >= 0 &&
                                      value.toInt() < weeks.length) {
                                    return Text(weeks[value.toInt()],
                                        style: const TextStyle(fontSize: 10));
                                  }
                                  return const Text('');
                                },
                                reservedSize: 24,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}%',
                                      style: const TextStyle(fontSize: 10));
                                },
                                reservedSize: 32,
                              ),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(
                              show: true, drawHorizontalLine: true),
                          barGroups: [
                            _makeBarData(0, 68, const Color(0xFF1D4ED8)),
                            _makeBarData(1, 72, const Color(0xFF1D4ED8)),
                            _makeBarData(2, 78, const Color(0xFF1D4ED8)),
                            _makeBarData(3, 74, const Color(0xFF1D4ED8)),
                            _makeBarData(4, 76, const Color(0xFF1D4ED8)),
                            _makeBarData(5, 80, const Color(0xFF1D4ED8)),
                            _makeBarData(6, 74, const Color(0xFFDC2626)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Course Performance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Course Performance',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildPerformanceRow('CS401 - Software Engineering', 65,
                        const Color(0xFFDC2626)),
                    const SizedBox(height: 12),
                    _buildPerformanceRow(
                        'CS301 - Data Structures', 88, const Color(0xFF16A34A)),
                    const SizedBox(height: 12),
                    _buildPerformanceRow('CS302 - Database Systems', 79,
                        const Color(0xFFD97706)),
                    const SizedBox(height: 12),
                    _buildPerformanceRow('CS403 - Networks & Security', 91,
                        const Color(0xFF16A34A)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quiz Performance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quiz Performance',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildQuizRow('Software Engineering Ch.7', 75),
                    _buildQuizRow('Data Structures - Trees', 80),
                    _buildQuizRow('Networks Module 5', 85),
                    _buildQuizRow('Database Systems CAT Prep', 88),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Risk Assessment Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Risk Assessment',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _buildRiskRow(
                        'Attendance Risk', 0.74, const Color(0xFFD97706)),
                    const SizedBox(height: 12),
                    _buildRiskRow(
                        'Engagement Risk', 0.61, const Color(0xFFD97706)),
                    const SizedBox(height: 12),
                    _buildRiskRow(
                        'Performance Risk', 0.68, const Color(0xFFD97706)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD97706).withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber, color: Color(0xFFD97706)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Recommended Action',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    'CS401 attendance is below 75%. Attend upcoming sessions to improve.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 24,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildPerformanceRow(String course, int percentage, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(course, style: const TextStyle(fontSize: 13))),
            Text('$percentage%',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 6,
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: const Color(0xFFE2E8F0),
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizRow(String quiz, int score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A).withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.quiz, color: Color(0xFF16A34A), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(quiz)),
          Text('$score%', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRiskRow(String label, double value, Color color) {
    final percent = (value * 100).toInt();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text('$percent%',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 6,
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: const Color(0xFFE2E8F0),
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}
