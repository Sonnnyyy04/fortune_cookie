import 'package:flutter/foundation.dart';

import '../../core/errors.dart';
import '../../data/session/session_store.dart';
import '../../domain/entities/prediction.dart';
import '../../domain/repository/prediction_repository.dart';


class HistoryController extends ChangeNotifier {
  HistoryController({
    required PredictionRepository predictionRepository,
    required SessionStore sessionStore,
  })  : _repo = predictionRepository,
        _session = sessionStore;

  final PredictionRepository _repo;
  final SessionStore _session;

  bool _loading = false;
  bool get loading => _loading;

  String _filter = 'all';
  String get filter => _filter;

  List<Prediction> _items = [];
  List<Prediction> get items => _items;

  Future<void> setFilter(String value) async {
    _filter = value;
    await load();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    try {
      final userId = await _session.getUserId();
      if (userId == null) throw NotLoggedInException();

      _items = await _repo.listPredictions(
        userId: userId,
        category: _filter == 'all' ? null : _filter,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> deleteById(int id) async {
    await _repo.deletePrediction(id);
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}