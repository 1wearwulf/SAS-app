import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> signIn(String email, String password);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, AuthUser?>> getCurrentUser();
  Stream<AuthUser?> watchAuthState();
}
