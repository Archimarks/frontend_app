import '../Entities/user_entity.dart';

abstract class LoginRepository {
  Future<UserEntity> login(final String username);
}
