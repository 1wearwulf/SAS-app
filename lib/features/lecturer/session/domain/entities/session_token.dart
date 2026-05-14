class SessionToken {
  final String qrData;      // Full data for QR code
  final String accessCode;  // 6-digit code for manual entry
  final DateTime createdAt;
  final DateTime expiresAt;
  
  SessionToken({
    required this.qrData,
    required this.accessCode,
    required this.createdAt,
    required this.expiresAt,
  });
  
  factory SessionToken.generate(String courseCode, int durationMinutes) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final qrData = "$courseCode:$timestamp:$durationMinutes";
    // Generate 6-digit code from timestamp
    final accessCode = (timestamp % 1000000).toString().padLeft(6, '0');
    
    return SessionToken(
      qrData: qrData,
      accessCode: accessCode,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(minutes: durationMinutes)),
    );
  }
  
  bool isValid() {
    return DateTime.now().isBefore(expiresAt);
  }
  
  bool validateCode(String code) {
    return accessCode == code && isValid();
  }
  
  bool validateQrData(String data) {
    // QR data format: "COURSECODE:TIMESTAMP:DURATION"
    final parts = data.split(':');
    if (parts.length != 3) return false;
    final codeFromQr = parts[1];
    return accessCode == codeFromQr && isValid();
  }
}
