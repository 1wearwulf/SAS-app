import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/session_config.dart';
import '../models/session_model.dart';

class FirestoreSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> startSession(SessionConfig config, String lecturerId, String lecturerName) async {
    final now = DateTime.now();
    final expiresAt = now.add(Duration(minutes: config.durationMinutes));
    final timestamp = now.millisecondsSinceEpoch;
    
    final qrData = "${config.courseCode}:$timestamp:${config.durationMinutes}";
    final accessCode = (timestamp % 1000000).toString().padLeft(6, '0');
    
    final session = SessionModel(
      id: '',
      courseCode: config.courseCode,
      courseName: config.courseName,
      lecturerId: lecturerId,
      lecturerName: lecturerName,
      room: config.room,
      startedAt: now,
      expiresAt: expiresAt,
      qrData: qrData,
      accessCode: accessCode,
      isActive: true,
      latitude: config.latitude,
      longitude: config.longitude,
      geofenceRadius: config.geofenceRadius,
      enableGeofencing: config.enableGeofencing,
      enableWifiVerification: config.enableWifiVerification,
      allowedSsid: config.allowedSsid,
    );
    
    await _firestore.collection('sessions').add(session.toFirestore());
  }
  
  Future<void> endSession(String sessionId) async {
    await _firestore.collection('sessions').doc(sessionId).update({'isActive': false});
  }
}
