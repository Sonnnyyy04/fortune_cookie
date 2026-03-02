import 'package:postgres/postgres.dart';

import '../../core/errors.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../db/postgres_db.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._db);

  final PostgresDb _db;

  int _asInt(Object? value) {
    if (value is int) return value;
    if (value is BigInt) return value.toInt();
    if (value is num) return value.toInt();
    return int.parse(value.toString());
  }

  @override
  Future<int> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _db.execute(
        '''
        INSERT INTO users(username, email, password)
        VALUES (\$1, \$2, \$3)
        RETURNING id
        ''',
        parameters: [username.trim(), email.trim().toLowerCase(), password],
      );

      if (result.isEmpty) {
        throw AppException('Не удалось зарегистрировать пользователя.');
      }
      return _asInt(result.first[0]);
    } on UniqueViolationException {
      throw AppException('Пользователь с таким email уже существует');
    }
  }

  @override
  Future<int?> login({required String email, required String password}) async {
    final result = await _db.execute(
      '''
      SELECT id
      FROM users
      WHERE email = \$1 AND password = \$2
      LIMIT 1
      ''',
      parameters: [email.trim().toLowerCase(), password],
    );

    if (result.isEmpty) return null;
    return _asInt(result.first[0]);
  }

  @override
  Future<User?> getUser(int userId) async {
    final result = await _db.execute(
      '''
      SELECT id, username, email
      FROM users
      WHERE id = \$1
      LIMIT 1
      ''',
      parameters: [userId],
    );

    if (result.isEmpty) return null;
    final row = result.first;
    return User(
      id: _asInt(row[0]),
      username: row[1] as String,
      email: row[2] as String,
    );
  }
}
