import 'dart:async';
import 'package:flutter/material.dart';

class AccessCodePanel extends StatefulWidget {
  final String accessCode;
  final String courseCode;
  final DateTime expiresAt;
  final Function(String code) onCodeValidated;
  
  const AccessCodePanel({
    super.key,
    required this.accessCode,
    required this.courseCode,
    required this.expiresAt,
    required this.onCodeValidated,
  });

  @override
  State<AccessCodePanel> createState() => _AccessCodePanelState();
}

class _AccessCodePanelState extends State<AccessCodePanel> {
  late Timer _timer;
  Duration _timeUntilRefresh = const Duration(seconds: 30);
  bool _isCopied = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatCode(String code) {
    if (code.length >= 6) {
      return '${code.substring(0, 3)} ${code.substring(3, 6)}';
    }
    return code.padLeft(6, '0');
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeUntilRefresh.inSeconds <= 1) {
          _refreshCode();
          _timeUntilRefresh = const Duration(seconds: 30);
        } else {
          _timeUntilRefresh = _timeUntilRefresh - const Duration(seconds: 1);
        }
      });
    });
  }

  void _refreshCode() {
    // Code refresh would need a new token from server
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code refreshed'), duration: Duration(seconds: 1)),
    );
  }

  void _copyToClipboard() {
    setState(() {
      _isCopied = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Access code copied!'), duration: Duration(seconds: 1)),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedCode = _formatCode(widget.accessCode);
    final isExpiring = _timeUntilRefresh.inSeconds < 10;
    
    return Container(
      constraints: const BoxConstraints(maxHeight: 450),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Access Code - ${widget.courseCode}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isExpiring ? Colors.red : Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  const Text(
                    'Share this access code with students:',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    formattedCode,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 4,
                      color: isExpiring ? Colors.red : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Valid until: ${widget.expiresAt.hour.toString().padLeft(2, '0')}:${widget.expiresAt.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isExpiring ? Colors.red.withAlpha(25) : Colors.orange.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Refreshes in ${_timeUntilRefresh.inSeconds}s',
                      style: TextStyle(
                        fontSize: 12,
                        color: isExpiring ? Colors.red : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: Icon(_isCopied ? Icons.check : Icons.copy),
                    label: Text(_isCopied ? 'Copied!' : 'Copy Code'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _refreshCode,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Regenerate'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Close'),
              ),
            ),
            
            const SizedBox(height: 8),
            const Text(
              'Students type this code in their mobile app',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
