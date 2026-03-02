import '../../core/errors.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../db/app_db.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._db);
  final AppDb _db;

  @override
  Future<int> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final d = await _db.db;
    try {
      return await d.insert('users', {
        'username': username.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
      });
    } catch (_) {
      throw AppException('Пользователь с таким email уже существует');
    }
  }

  @override
  Future<int?> login({
    required String email,
    required String password,
  }) async {
    final d = await _db.db;
    final rows = await d.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['id'] as int;
  }

  @override
  Future<User?> getUser(int userId) async {
    final d = await _db.db;
    final rows = await d.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    return User(
      id: r['id'] as int,
      username: r['username'] as String,
      email: r['email'] as String,
    );
  }
}