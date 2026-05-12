import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  AuthRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, AuthUser>> signIn(String email, String password) async {
    try {
      final userModel = await remoteDataSource.signIn(email, password);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(AuthFailure('Sign in failed: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Sign out failed: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return Right(userModel?.toEntity());
    } catch (e) {
      return Left(AuthFailure('Failed to get current user: ${e.toString()}'));
    }
  }
  
  @override
  Stream<AuthUser?> watchAuthState() {
    return remoteDataSource.watchAuthState().map((userModel) {
      return userModel?.toEntity();
    });
  }
}
