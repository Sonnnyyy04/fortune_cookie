import '../entities/user.dart';

abstract class AuthRepository {
  Future<int> register({
    required String username,
    required String email,
    required String password,
  });

  Future<int?> login({
    required String email,
    required String password,
  });

  Future<User?> getUser(int userId);
}