import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  
  SignUpUseCase(this.repository);
  
  Future<Either<Failure, AuthUser>> call(String email, String password, String name, String role) {
    return repository.signUp(email, password, name, role);
  }
}
