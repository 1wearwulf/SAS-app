import 'package:flutter/material.dart';

class BroadcastNotification extends StatefulWidget {
  final String courseCode;
  final String courseName;
  
  const BroadcastNotification({
    super.key,
    required this.courseCode,
    required this.courseName,
  });

  @override
  State<BroadcastNotification> createState() => _BroadcastNotificationState();
}

class _BroadcastNotificationState extends State<BroadcastNotification> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isUrgent = false;
  bool _isSending = false;
  String? _errorMessage;

  Future<void> _sendAnnouncement() async {
    setState(() {
      _isSending = true;
      _errorMessage = null;
    });
    
    try {
      // TODO: Send to Firebase
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Announcement sent to ${widget.courseCode} students!'),
            backgroundColor: _isUrgent ? Colors.red : Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to send: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _titleController.text.isNotEmpty && _messageController.text.isNotEmpty;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(_isUrgent ? Icons.warning : Icons.announcement, 
                     color: _isUrgent ? Colors.red : Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Send Announcement - ${widget.courseCode}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Priority Toggle
            Row(
              children: [
                const Text('Priority:'),
                const SizedBox(width: 12),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Normal')),
                    ButtonSegment(value: true, label: Text('Urgent')),
                  ],
                  selected: {_isUrgent},
                  onSelectionChanged: (Set<bool> selection) {
                    setState(() {
                      _isUrgent = selection.first;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Announcement Title',
                hintText: 'e.g., Class Cancelled, Assignment Update...',
                border: const OutlineInputBorder(),
                counter: const Text('Max 80 characters'),
              ),
              maxLength: 80,
            ),
            const SizedBox(height: 16),
            
            // Message Body
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Type your announcement here...',
                border: const OutlineInputBorder(),
                counter: const Text('Max 500 characters'),
              ),
              maxLength: 500,
            ),
            const SizedBox(height: 16),
            
            // Preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _isUrgent ? Colors.red : Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview:',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isUrgent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'URGENT',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          _titleController.text.isEmpty ? 'Announcement Title' : _titleController.text,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _messageController.text.isEmpty ? 'Your message will appear here...' : _messageController.text,
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            
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
                    onPressed: isValid && !_isSending ? _sendAnnouncement : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isUrgent ? Colors.red : Colors.blue,
                    ),
                    child: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Send Announcement →'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
