import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
  });
  
  factory AuthUserModel.fromEntity(AuthUser entity) {
    return AuthUserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      role: entity.role,
    );
  }
  
  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      name: name,
      role: role,
    );
  }
}
