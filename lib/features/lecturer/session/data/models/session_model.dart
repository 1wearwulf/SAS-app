import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;
  final String courseCode;
  final String courseName;
  final String lecturerId;
  final String lecturerName;
  final String room;
  final DateTime startedAt;
  final DateTime expiresAt;
  final String qrData;
  final String accessCode;
  final bool isActive;
  final double latitude;
  final double longitude;
  final double geofenceRadius;
  final bool enableGeofencing;
  final bool enableWifiVerification;
  final String? allowedSsid;
  
  SessionModel({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.lecturerId,
    required this.lecturerName,
    required this.room,
    required this.startedAt,
    required this.expiresAt,
    required this.qrData,
    required this.accessCode,
    required this.isActive,
    required this.latitude,
    required this.longitude,
    required this.geofenceRadius,
    required this.enableGeofencing,
    required this.enableWifiVerification,
    this.allowedSsid,
  });
  
  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SessionModel(
      id: doc.id,
      courseCode: data['courseCode'] ?? '',
      courseName: data['courseName'] ?? '',
      lecturerId: data['lecturerId'] ?? '',
      lecturerName: data['lecturerName'] ?? '',
      room: data['room'] ?? '',
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      qrData: data['qrData'] ?? '',
      accessCode: data['accessCode'] ?? '',
      isActive: data['isActive'] ?? false,
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      geofenceRadius: data['geofenceRadius'] ?? 100.0,
      enableGeofencing: data['enableGeofencing'] ?? false,
      enableWifiVerification: data['enableWifiVerification'] ?? false,
      allowedSsid: data['allowedSsid'],
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'lecturerId': lecturerId,
      'lecturerName': lecturerName,
      'room': room,
      'startedAt': Timestamp.fromDate(startedAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'qrData': qrData,
      'accessCode': accessCode,
      'isActive': isActive,
      'latitude': latitude,
      'longitude': longitude,
      'geofenceRadius': geofenceRadius,
      'enableGeofencing': enableGeofencing,
      'enableWifiVerification': enableWifiVerification,
      'allowedSsid': allowedSsid,
    };
  }
}
