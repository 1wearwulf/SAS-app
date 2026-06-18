class AttendanceRecord {
  final String studentId;
  final String studentName;
  final String studentReg;
  final String sessionId;
  final String courseCode;
  final DateTime timestamp;
  final String method; // 'qr', 'manual', 'code'
  final bool qrValidated;
  final bool locationValidated;
  final bool wifiValidated;
  final bool deviceValidated;
  final bool quizParticipated;
  final double riskScore;
  final String finalStatus; // 'fully_present', 'partial', 'absent'
  final String? manualJustification;
  
  AttendanceRecord({
    required this.studentId,
    required this.studentName,
    required this.studentReg,
    required this.sessionId,
    required this.courseCode,
    required this.timestamp,
    required this.method,
    this.qrValidated = false,
    this.locationValidated = false,
    this.wifiValidated = false,
    this.deviceValidated = false,
    this.quizParticipated = false,
    this.riskScore = 0.0,
    this.finalStatus = 'absent',
    this.manualJustification,
  });
  
  bool get isFullyPresent => 
    qrValidated && 
    (locationValidated || wifiValidated) && 
    deviceValidated && 
    quizParticipated;
    
  String get riskLevel {
    if (riskScore >= 0.7) return 'CRITICAL';
    if (riskScore >= 0.5) return 'WARNING';
    return 'SAFE';
  }
}
