class SessionConfig {
  final String courseCode;
  final String courseName;
  final String room;
  final int durationMinutes;
  final double geofenceRadius;
  final double latitude;
  final double longitude;
  final String? locationName;
  final bool enableGeofencing;
  final bool enableWifiVerification;
  final String? allowedSsid;
  
  SessionConfig({
    required this.courseCode,
    required this.courseName,
    required this.room,
    required this.durationMinutes,
    this.geofenceRadius = 100.0,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.locationName,
    this.enableGeofencing = true,
    this.enableWifiVerification = false,
    this.allowedSsid,
  });
  
  Map<String, dynamic> toJson() => {
    'courseCode': courseCode,
    'courseName': courseName,
    'room': room,
    'durationMinutes': durationMinutes,
    'geofenceRadius': geofenceRadius,
    'latitude': latitude,
    'longitude': longitude,
    'locationName': locationName,
    'enableGeofencing': enableGeofencing,
    'enableWifiVerification': enableWifiVerification,
    'allowedSsid': allowedSsid,
  };
}
