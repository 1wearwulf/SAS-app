import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class BatchAttendanceService {
  static final BatchAttendanceService _instance =
      BatchAttendanceService._internal();
  factory BatchAttendanceService() => _instance;
  BatchAttendanceService._internal();

  final List<Map<String, dynamic>> _pendingRecords = [];
  Timer? _batchTimer;
  bool _isProcessing = false;

  void addAttendanceRecord({
    required String studentId,
    required String studentName,
    required String sessionId,
    required String courseCode,
    required String method,
    required bool qrValidated,
    required bool locationValidated,
    required bool wifiValidated,
    required double riskScore,
  }) {
    _pendingRecords.add({
      'studentId': studentId,
      'studentName': studentName,
      'sessionId': sessionId,
      'courseCode': courseCode,
      'method': method,
      'qrValidated': qrValidated,
      'locationValidated': locationValidated,
      'wifiValidated': wifiValidated,
      'riskScore': riskScore,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Start timer if not already running
    _startBatchTimer();

    // Process immediately if we have 50+ records
    if (_pendingRecords.length >= 50) {
      _processBatch();
    }
  }

  void _startBatchTimer() {
    if (_batchTimer != null) return;
    _batchTimer = Timer(const Duration(seconds: 5), () {
      _processBatch();
    });
  }

  Future<void> _processBatch() async {
    if (_isProcessing || _pendingRecords.isEmpty) return;

    _isProcessing = true;
    _batchTimer?.cancel();
    _batchTimer = null;

    final batch = FirebaseFirestore.instance.batch();
    final recordsToProcess = List<Map<String, dynamic>>.from(_pendingRecords);
    _pendingRecords.clear();

    for (final record in recordsToProcess) {
      final docRef = FirebaseFirestore.instance.collection('attendance').doc();
      batch.set(docRef, record);
    }

    try {
      await batch.commit();
      print('✅ Batch saved: ${recordsToProcess.length} records');
    } catch (e) {
      print('❌ Batch failed: $e');
      // Re-add failed records
      _pendingRecords.addAll(recordsToProcess);
    }

    _isProcessing = false;

    // Process remaining if any
    if (_pendingRecords.isNotEmpty) {
      _startBatchTimer();
    }
  }

  Future<void> flush() async {
    _batchTimer?.cancel();
    await _processBatch();
  }
}
