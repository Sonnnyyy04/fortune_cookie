import 'package:flutter/foundation.dart';

import '../../core/errors.dart';
import '../../data/session/session_store.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/repository/prediction_repository.dart';


class ProfileController extends ChangeNotifier {
  ProfileController({
    required AuthRepository authRepository,
    required PredictionRepository predictionRepository,
    required SessionStore sessionStore,
  })  : _authRepo = authRepository,
        _predRepo = predictionRepository,
        _session = sessionStore;

  final AuthRepository _authRepo;
  final PredictionRepository _predRepo;
  final SessionStore _session;

  bool _loading = false;
  bool get loading => _loading;

  User? _user;
  User? get user => _user;

  Map<String, int> _stats = {};
  Map<String, int> get stats => _stats;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    try {
      final userId = await _session.getUserId();
      if (userId == null) throw NotLoggedInException();

      _user = await _authRepo.getUser(userId);
      _stats = await _predRepo.statsByCategory(userId);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}