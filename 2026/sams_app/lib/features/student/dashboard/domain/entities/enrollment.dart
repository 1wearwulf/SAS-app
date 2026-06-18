class Enrollment {
  final String id;
  final String studentId;
  final String unitId;
  final String unitCode;
  final String unitName;
  final String lecturer;
  final String semester;
  final int year;
  final String status;
  final DateTime enrolledAt;
  final DateTime? updatedAt;
  
  Enrollment({
    required this.id,
    required this.studentId,
    required this.unitId,
    required this.unitCode,
    required this.unitName,
    required this.lecturer,
    required this.semester,
    required this.year,
    required this.status,
    required this.enrolledAt,
    this.updatedAt,
  });
  
  bool get isActive => status == 'active';
  bool get isDeferred => status == 'deferred';
}
