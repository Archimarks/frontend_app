import '../Entities/user_entity.dart';
import '../Repositories/login_repository.dart';

class LoginUseCase {

  LoginUseCase(this.repository);
  final LoginRepository repository;

  Future<UserEntity> call(final String username) => repository.login(username);
}
