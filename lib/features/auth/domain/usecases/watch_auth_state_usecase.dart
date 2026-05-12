import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  final AuthRepository repository;
  
  WatchAuthStateUseCase(this.repository);
  
  Stream<AuthUser?> call() {
    return repository.watchAuthState();
  }
}
