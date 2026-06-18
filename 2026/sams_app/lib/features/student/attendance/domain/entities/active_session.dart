class ActiveSession {
  final String sessionId;
  final String courseCode;
  final String courseName;
  final String lecturer;
  final String room;
  final DateTime startedAt;
  final DateTime expiresAt;
  final String qrData;
  final String accessCode;
  
  ActiveSession({
    required this.sessionId,
    required this.courseCode,
    required this.courseName,
    required this.lecturer,
    required this.room,
    required this.startedAt,
    required this.expiresAt,
    required this.qrData,
    required this.accessCode,
  });
  
  bool get isActive => DateTime.now().isBefore(expiresAt);
  
  Duration get timeRemaining => expiresAt.difference(DateTime.now());
  
  String get formattedTimeRemaining {
    final duration = timeRemaining;
    if (duration.isNegative) return 'Expired';
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
