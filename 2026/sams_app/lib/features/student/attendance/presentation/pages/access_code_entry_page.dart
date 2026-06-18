import 'package:flutter/material.dart';
import '../../data/services/student_session_service.dart';

class AccessCodeEntryPage extends StatefulWidget {
  final VoidCallback onSuccess;
  
  const AccessCodeEntryPage({super.key, required this.onSuccess});

  @override
  State<AccessCodeEntryPage> createState() => _AccessCodeEntryPageState();
}

class _AccessCodeEntryPageState extends State<AccessCodeEntryPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  void _submit() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Enter 6-digit code');
      return;
    }
    
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    
    final session = StudentSessionService().currentSession;
    
    if (session == null) {
      setState(() {
        _error = 'No active session found';
        _isSubmitting = false;
      });
      return;
    }
    
    if (!session.isActive) {
      setState(() {
        _error = 'Session has expired';
        _isSubmitting = false;
      });
      return;
    }
    
    if (code == session.accessCode) {
      widget.onSuccess();
      if (mounted) Navigator.pop(context);
    } else {
      setState(() {
        _error = 'Invalid access code';
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = StudentSessionService().currentSession;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Access Code'), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text('Enter the 6-digit code from your lecturer', textAlign: TextAlign.center),
            if (session != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('${session.courseCode} - ${session.courseName}', style: const TextStyle(fontSize: 12)),
              ),
            const SizedBox(height: 32),
            TextField(
              controller: _codeController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), counterText: ''),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isSubmitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : const Text('Submit', style: TextStyle(fontSize: 18)),
            ),
            if (_error != null) Padding(padding: const EdgeInsets.only(top: 16), child: Text(_error!, style: const TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }
}
