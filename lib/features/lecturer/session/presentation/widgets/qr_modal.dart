import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRModal extends StatelessWidget {
  final String qrData;
  final String courseCode;
  final String courseName;
  final String room;
  final DateTime expiresAt;
  final String accessCode;
  
  const QRModal({
    super.key,
    required this.qrData,
    required this.courseCode,
    required this.courseName,
    required this.room,
    required this.expiresAt,
    required this.accessCode,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('QR Code - $courseCode', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(data: qrData, version: QrVersions.auto, size: 200),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text('Manual Access Code:', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(
                    _formatCode(accessCode),
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'monospace', letterSpacing: 4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, size: 14),
                      const SizedBox(width: 4),
                      Text('Valid until: ${expiresAt.hour.toString().padLeft(2, '0')}:${expiresAt.minute.toString().padLeft(2, '0')}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('QR saved'))),
                    icon: const Icon(Icons.download),
                    label: const Text('Save QR'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatCode(String code) {
    if (code.length >= 6) return '${code.substring(0, 3)} ${code.substring(3, 6)}';
    return code.padLeft(6, '0');
  }
}
