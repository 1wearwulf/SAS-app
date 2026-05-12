import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/enrollment.dart';

abstract class EnrollmentState {}
class EnrollmentInitial extends EnrollmentState {}
class EnrollmentLoading extends EnrollmentState {}
class EnrollmentLoaded extends EnrollmentState {
  final List<Enrollment> enrollments;
  EnrollmentLoaded({required this.enrollments});
}
class EnrollmentError extends EnrollmentState {
  final String message;
  EnrollmentError({required this.message});
}

class EnrollmentCubit extends Cubit<EnrollmentState> {
  EnrollmentCubit() : super(EnrollmentInitial()) {
    // Load mock data for now
    _loadMockData();
  }
  
  void _loadMockData() {
    emit(EnrollmentLoading());
    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      emit(EnrollmentLoaded(enrollments: [
        Enrollment(
          id: '1',
          studentId: 'student1',
          unitId: 'CS401',
          unitCode: 'CS401',
          unitName: 'Software Engineering',
          lecturer: 'Dr. Ochieng',
          semester: 'Semester 2',
          year: 2026,
          status: 'active',
          enrolledAt: DateTime.now(),
        ),
        Enrollment(
          id: '2',
          studentId: 'student1',
          unitId: 'CS301',
          unitCode: 'CS301',
          unitName: 'Data Structures & Algorithms',
          lecturer: 'Dr. Kamau',
          semester: 'Semester 2',
          year: 2026,
          status: 'active',
          enrolledAt: DateTime.now(),
        ),
        Enrollment(
          id: '3',
          studentId: 'student1',
          unitId: 'CS302',
          unitCode: 'CS302',
          unitName: 'Database Systems',
          lecturer: 'Prof. Njoroge',
          semester: 'Semester 2',
          year: 2026,
          status: 'deferred',
          enrolledAt: DateTime.now(),
        ),
      ]));
    });
  }
}
