import '../../Domain/Entities/user_entity.dart';
import '../../Domain/Repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<UserEntity> login(final String username) async {
    await Future.delayed(const Duration(seconds: 2)); // Simular red

    if (username.isNotEmpty && username.length > 2) {
      return UserEntity(username: username);
    } else {
      throw Exception('Usuario inválido');
    }
  }
}
