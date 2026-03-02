import 'package:flutter/foundation.dart';

import '../../core/errors.dart';
import '../../data/session/session_store.dart';
import '../../domain/services/fortune_service.dart';

class PredictionController extends ChangeNotifier {
  PredictionController({
    required FortuneService fortuneService,
    required SessionStore sessionStore,
  })  : _service = fortuneService,
        _session = sessionStore;

  final FortuneService _service;
  final SessionStore _session;

  bool _loading = false;
  bool get loading => _loading;

  String? _prediction;
  String? get prediction => _prediction;

  Future<void> openToday(String category) async {
    _loading = true;
    _prediction = null;
    notifyListeners();

    try {
      final userId = await _session.getUserId();
      if (userId == null) throw NotLoggedInException();

      final text = await _service.openTodayPrediction(
        userId: userId,
        category: category,
      );
      _prediction = text;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void reset() {
    _prediction = null;
    _loading = false;
    notifyListeners();
  }
}