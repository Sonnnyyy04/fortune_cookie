import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/core/date_utils.dart';
import 'package:untitled/core/errors.dart';
import 'package:untitled/domain/entities/prediction.dart';
import 'package:untitled/domain/repository/prediction_repository.dart';
import 'package:untitled/domain/services/fortune_service.dart';

void main() {
  group('FortuneService', () {
    test('returns the same prediction for same user/category/day', () async {
      final repo = _FakePredictionRepository();
      var now = DateTime(2026, 3, 2, 10, 0);
      final service = FortuneService(
        predictionRepository: repo,
        now: () => now,
      );

      final first = await service.openTodayPrediction(
        userId: 1,
        category: 'main',
      );
      final second = await service.openTodayPrediction(
        userId: 1,
        category: 'main',
      );

      expect(second, first);
      expect(
        await repo.countPredictionsForDay(
          userId: 1,
          dayKey: DateUtilsX.dayKey(now),
        ),
        1,
      );
    });

    test(
      'throws DailyLimitReachedException after 4 predictions per day',
      () async {
        final repo = _FakePredictionRepository();
        final now = DateTime(2026, 3, 2, 10, 0);
        final service = FortuneService(
          predictionRepository: repo,
          now: () => now,
        );

        await service.openTodayPrediction(userId: 1, category: 'main');
        await service.openTodayPrediction(userId: 1, category: 'love');
        await service.openTodayPrediction(userId: 1, category: 'career');
        await service.openTodayPrediction(userId: 1, category: 'health');

        expect(
          () => service.openTodayPrediction(userId: 1, category: 'finance'),
          throwsA(isA<DailyLimitReachedException>()),
        );
      },
    );

    test('allows opening category again on next day', () async {
      final repo = _FakePredictionRepository();
      var now = DateTime(2026, 3, 2, 10, 0);
      final service = FortuneService(
        predictionRepository: repo,
        now: () => now,
      );

      await service.openTodayPrediction(userId: 1, category: 'main');
      now = now.add(const Duration(days: 1));
      await service.openTodayPrediction(userId: 1, category: 'main');

      expect(
        await repo.countPredictionsForDay(userId: 1, dayKey: '2026-03-02'),
        1,
      );
      expect(
        await repo.countPredictionsForDay(userId: 1, dayKey: '2026-03-03'),
        1,
      );
    });
  });
}

class _FakePredictionRepository implements PredictionRepository {
  final List<Prediction> _rows = [];
  final Map<String, List<String>> _templates = {
    'main': ['main-1', 'main-2'],
    'love': ['love-1', 'love-2'],
    'career': ['career-1', 'career-2'],
    'health': ['health-1', 'health-2'],
    'finance': ['finance-1', 'finance-2'],
  };

  int _id = 1;

  @override
  Future<int> countPredictionsForDay({
    required int userId,
    required String dayKey,
  }) async {
    return _rows.where((p) => p.userId == userId && p.dayKey == dayKey).length;
  }

  @override
  Future<void> deletePrediction(int id) async {
    _rows.removeWhere((p) => p.id == id);
  }

  @override
  Future<Prediction?> getPredictionForDay({
    required int userId,
    required String dayKey,
    required String category,
  }) async {
    for (final row in _rows) {
      if (row.userId == userId &&
          row.dayKey == dayKey &&
          row.category == category) {
        return row;
      }
    }
    return null;
  }

  @override
  Future<int> insertPrediction({
    required int userId,
    required String category,
    required String createdAtIso,
    required String dayKey,
  }) async {
    final id = _id++;
    final templates = _templates[category] ?? _templates['main']!;
    final generatedText = templates[id % templates.length];

    _rows.add(
      Prediction(
        id: id,
        userId: userId,
        category: category,
        text: generatedText,
        createdAtIso: createdAtIso,
        dayKey: dayKey,
      ),
    );
    return id;
  }

  @override
  Future<List<Prediction>> listPredictions({
    required int userId,
    String? category,
  }) async {
    return _rows
        .where(
          (p) =>
              p.userId == userId &&
              (category == null || p.category == category),
        )
        .toList();
  }

  @override
  Future<Map<String, int>> statsByCategory(int userId) async {
    final result = <String, int>{};
    for (final row in _rows.where((p) => p.userId == userId)) {
      result[row.category] = (result[row.category] ?? 0) + 1;
    }
    return result;
  }
}
