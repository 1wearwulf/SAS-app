import 'package:flutter/material.dart';

import 'dart:async';

class ActiveSessionCard extends StatefulWidget {
  final Map<String, dynamic> session;
  final VoidCallback onEndSession;
  final VoidCallback onShowQR;
  final VoidCallback onManualCode;
  final VoidCallback onManualAttendance;
  
  const ActiveSessionCard({
    super.key,
    required this.session,
    required this.onEndSession,
    required this.onShowQR,
    required this.onManualCode,
    required this.onManualAttendance,
  });

  @override
  State<ActiveSessionCard> createState() => _ActiveSessionCardState();
}

class _ActiveSessionCardState extends State<ActiveSessionCard> {
  late Timer _timer;
  late Duration _timeRemaining;
  late DateTime _expiresAt;

  @override
  void initState() {
    super.initState();
    _expiresAt = widget.session['expiresAt'] as DateTime;
    _timeRemaining = _expiresAt.difference(DateTime.now());
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining = _expiresAt.difference(DateTime.now());
        if (_timeRemaining.isNegative) {
          _timer.cancel();
        }
      });
    });
  }

  String _formatTimeRemaining() {
    if (_timeRemaining.isNegative) return '00:00';
    final minutes = _timeRemaining.inMinutes.remainder(60);
    final seconds = _timeRemaining.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isExpiring = _timeRemaining.inMinutes < 5 && _timeRemaining.inMinutes > 0;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1D4ED8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2563EB), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Live indicator
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Course info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.session['courseName'],
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.session['courseCode']} • ${widget.session['room']}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Timer centered
            Center(
              child: Column(
                children: [
                  Text(
                    _formatTimeRemaining(),
                    style: TextStyle(
                      fontFamily: 'DM Mono',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: isExpiring ? const Color(0xFFF59E0B) : Colors.white,
                    ),
                  ),
                  const Text(
                    'Time remaining',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Stats row
            Row(
              children: [
                _StatChip(label: 'Present', value: '${widget.session['present'] ?? 29}', color: const Color(0xFF16A34A)),
                const SizedBox(width: 12),
                _StatChip(label: 'Flagged', value: '${widget.session['flagged'] ?? 4}', color: const Color(0xFFD97706)),
                const SizedBox(width: 12),
                _StatChip(label: 'Absent', value: '${widget.session['absent'] ?? 11}', color: const Color(0xFFDC2626)),
              ],
            ),
            const SizedBox(height: 20),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onShowQR,
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Show QR'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1D4ED8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onManualCode,
                    icon: const Icon(Icons.keyboard),
                    label: const Text('Manual Code'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1D4ED8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onManualAttendance,
                    icon: const Icon(Icons.edit_note),
                    label: const Text('Manual'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1D4ED8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: widget.onEndSession,
                icon: const Icon(Icons.stop),
                label: const Text('End Session'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(38),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
