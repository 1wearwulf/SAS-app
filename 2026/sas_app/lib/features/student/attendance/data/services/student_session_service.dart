import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/active_session.dart';

class StudentSessionService {
  static final StudentSessionService _instance = StudentSessionService._internal();
  factory StudentSessionService() => _instance;
  StudentSessionService._internal();
  
  final StreamController<ActiveSession?> _sessionController = StreamController.broadcast();
  Stream<ActiveSession?> get activeSessionStream => _sessionController.stream;
  
  ActiveSession? _currentSession;
  StreamSubscription<QuerySnapshot>? _subscription;
  
  void startListening() {
    
    _subscription = FirebaseFirestore.instance
        .collection('sessions')
        .where('isActive', isEqualTo: true)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final doc = snapshot.docs.first;
            final data = doc.data();
            _currentSession = ActiveSession(
              sessionId: doc.id,
              courseCode: data['courseCode'] ?? '',
              courseName: data['courseName'] ?? '',
              lecturer: data['lecturerName'] ?? '',
              room: data['room'] ?? '',
              startedAt: (data['startedAt'] as Timestamp).toDate(),
              expiresAt: (data['expiresAt'] as Timestamp).toDate(),
              qrData: data['qrData'] ?? '',
              accessCode: data['accessCode'] ?? '',
            );
            _sessionController.add(_currentSession);
          } else {
            _currentSession = null;
            _sessionController.add(null);
          }
        }, onError: (error) {
        });
  }
  
  void stopListening() {
    _subscription?.cancel();
  }
  
  ActiveSession? get currentSession => _currentSession;
  
  void dispose() {
    stopListening();
    _sessionController.close();
  }
}
