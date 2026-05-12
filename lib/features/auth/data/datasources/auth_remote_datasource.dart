import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/auth_user_model.dart';

class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  
  AuthRemoteDataSource({required this.firebaseAuth});
  
  Future<AuthUserModel> signIn(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final user = userCredential.user;
    if (user == null) {
      throw Exception('User not found');
    }
    
    // For now, return a basic user model
    // In production, fetch role from Firestore
    return AuthUserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      role: 'student', // Temporary - will come from custom claims
    );
  }
  
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
  
  Future<AuthUserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    
    return AuthUserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      role: 'student',
    );
  }
  
  Stream<AuthUserModel?> watchAuthState() {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      
      return AuthUserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'User',
        role: 'student',
      );
    });
  }
}
