import 'package:flutter/foundation.dart';

import '../../core/errors.dart';
import '../../data/session/session_store.dart';
import '../../domain/repository/auth_repository.dart';


class AuthController extends ChangeNotifier {
  AuthController({
    required AuthRepository authRepository,
    required SessionStore sessionStore,
  })  : _authRepo = authRepository,
        _session = sessionStore;

  final AuthRepository _authRepo;
  final SessionStore _session;

  bool _loading = false;
  bool get loading => _loading;

  Future<int?> currentUserId() => _session.getUserId();

  Future<void> logout() async {
    await _session.clear();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final id = await _authRepo.login(email: email, password: password);
      if (id == null) throw AppException('Неверный email или пароль');
      await _session.setUserId(id);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final id = await _authRepo.register(
        username: username,
        email: email,
        password: password,
      );
      await _session.setUserId(id);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}