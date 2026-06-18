import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/auth_user_model.dart';

class AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  
  AuthRemoteDataSource({required this.firebaseAuth, required this.firestore});
  
  Future<AuthUserModel> signIn(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final user = userCredential.user;
    if (user == null) {
      throw Exception('User not found');
    }
    
    // Fetch user role from Firestore
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();
    final role = userData?['role'] ?? 'student';
    
    return AuthUserModel(
      id: user.uid,
      email: user.email ?? '',
      name: userData?['name'] ?? user.displayName ?? 'User',
      role: role,
    );
  }
  
  Future<AuthUserModel> signUp(String email, String password, String name, String role) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    final user = userCredential.user;
    if (user == null) {
      throw Exception('User creation failed');
    }
    
    // Save user data to Firestore
    await firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    // Update display name
    await user.updateDisplayName(name);
    
    return AuthUserModel(
      id: user.uid,
      email: email,
      name: name,
      role: role,
    );
  }
  
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
  
  Future<AuthUserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();
    
    return AuthUserModel(
      id: user.uid,
      email: user.email ?? '',
      name: userData?['name'] ?? user.displayName ?? 'User',
      role: userData?['role'] ?? 'student',
    );
  }
  
  Stream<AuthUserModel?> watchAuthState() {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();
      
      return AuthUserModel(
        id: user.uid,
        email: user.email ?? '',
        name: userData?['name'] ?? user.displayName ?? 'User',
        role: userData?['role'] ?? 'student',
      );
    });
  }
}
