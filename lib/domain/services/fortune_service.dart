import '../../core/date_utils.dart';
import '../../core/errors.dart';
import '../repository/prediction_repository.dart';

class FortuneService {
  FortuneService({
    required PredictionRepository predictionRepository,
    DateTime Function()? now,
  }) : _repo = predictionRepository,
       _now = now ?? DateTime.now;

  final PredictionRepository _repo;
  final DateTime Function() _now;

  Future<String> openTodayPrediction({
    required int userId,
    required String category,
  }) async {
    final now = _now();
    final dayKey = DateUtilsX.dayKey(now);

    final existing = await _repo.getPredictionForDay(
      userId: userId,
      dayKey: dayKey,
      category: category,
    );
    if (existing != null) return existing.text;

    final count = await _repo.countPredictionsForDay(
      userId: userId,
      dayKey: dayKey,
    );
    if (count >= 4) throw DailyLimitReachedException();

    await _repo.insertPrediction(
      userId: userId,
      category: category,
      createdAtIso: now.toIso8601String(),
      dayKey: dayKey,
    );

    final created = await _repo.getPredictionForDay(
      userId: userId,
      dayKey: dayKey,
      category: category,
    );
    if (created == null) {
      throw AppException('Не удалось получить предсказание. Попробуйте снова.');
    }

    return created.text;
  }
}
