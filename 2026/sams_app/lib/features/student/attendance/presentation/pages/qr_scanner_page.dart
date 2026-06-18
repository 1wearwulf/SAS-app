import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/services/student_session_service.dart';

class QRScannerPage extends StatefulWidget {
  final VoidCallback onSuccess;
  
  const QRScannerPage({super.key, required this.onSuccess});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _processQr(String data) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
      _error = null;
    });
    
    final session = StudentSessionService().currentSession;
    
    if (session == null) {
      setState(() {
        _error = 'No active session found';
        _isProcessing = false;
      });
      return;
    }
    
    if (!session.isActive) {
      setState(() {
        _error = 'Session has expired';
        _isProcessing = false;
      });
      return;
    }
    
    if (data == session.qrData) {
      widget.onSuccess();
      if (mounted) Navigator.pop(context);
    } else {
      setState(() {
        _error = 'Invalid QR code for this session';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = StudentSessionService().currentSession;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.flash_on), onPressed: () => _controller.toggleTorch()),
          IconButton(icon: const Icon(Icons.switch_camera), onPressed: () => _controller.switchCamera()),
        ],
      ),
      body: Column(
        children: [
          if (session != null)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.blue.shade50,
              child: Text('Session: ${session.courseCode} - ${session.courseName}'),
            ),
          Expanded(
            child: MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                final barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    _processQr(barcode.rawValue!);
                    break;
                  }
                }
              },
            ),
          ),
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.red.shade50,
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_error!)),
                  TextButton(
                    onPressed: () => setState(() { _error = null; _isProcessing = false; }),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
