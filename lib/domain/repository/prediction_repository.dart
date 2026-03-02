import '../entities/prediction.dart';

abstract class PredictionRepository {
  Future<Prediction?> getPredictionForDay({
    required int userId,
    required String dayKey,
    required String category,
  });

  Future<int> countPredictionsForDay({
    required int userId,
    required String dayKey,
  });

  Future<int> insertPrediction({
    required int userId,
    required String category,
    required String text,
    required String createdAtIso,
    required String dayKey,
  });

  Future<List<Prediction>> listPredictions({
    required int userId,
    String? category, // null = all
  });

  Future<void> deletePrediction(int id);

  Future<Map<String, int>> statsByCategory(int userId);
}