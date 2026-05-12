class AuthUser {
  final String id;
  final String email;
  final String name;
  final String role;
  
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
  
  bool get isStudent => role == 'student';
  bool get isLecturer => role == 'lecturer';
  bool get isAdmin => role == 'admin';
}
