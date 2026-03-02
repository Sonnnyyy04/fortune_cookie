import '../../domain/entities/prediction.dart';
import '../../domain/repository/prediction_repository.dart';
import '../db/app_db.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  PredictionRepositoryImpl(this._db);
  final AppDb _db;

  Prediction _mapToPrediction(Map<String, Object?> r) {
    return Prediction(
      id: r['id'] as int,
      userId: r['user_id'] as int,
      category: r['category'] as String,
      text: r['text'] as String,
      createdAtIso: r['created_at'] as String,
      dayKey: r['day_key'] as String,
    );
  }

  @override
  Future<Prediction?> getPredictionForDay({
    required int userId,
    required String dayKey,
    required String category,
  }) async {
    final d = await _db.db;
    final rows = await d.query(
      'predictions',
      where: 'user_id = ? AND day_key = ? AND category = ?',
      whereArgs: [userId, dayKey, category],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _mapToPrediction(rows.first);
  }

  @override
  Future<int> countPredictionsForDay({
    required int userId,
    required String dayKey,
  }) async {
    final d = await _db.db;
    final res = await d.rawQuery(
      'SELECT COUNT(*) as cnt FROM predictions WHERE user_id = ? AND day_key = ?',
      [userId, dayKey],
    );
    return (res.first['cnt'] as int?) ?? 0;
  }

  @override
  Future<int> insertPrediction({
    required int userId,
    required String category,
    required String text,
    required String createdAtIso,
    required String dayKey,
  }) async {
    final d = await _db.db;
    return d.insert('predictions', {
      'user_id': userId,
      'category': category,
      'text': text,
      'created_at': createdAtIso,
      'day_key': dayKey,
    });
  }

  @override
  Future<List<Prediction>> listPredictions({
    required int userId,
    String? category,
  }) async {
    final d = await _db.db;
    final rows = await d.query(
      'predictions',
      where: category == null ? 'user_id = ?' : 'user_id = ? AND category = ?',
      whereArgs: category == null ? [userId] : [userId, category],
      orderBy: 'created_at DESC',
    );
    return rows.map(_mapToPrediction).toList();
  }

  @override
  Future<void> deletePrediction(int id) async {
    final d = await _db.db;
    await d.delete('predictions', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<Map<String, int>> statsByCategory(int userId) async {
    final d = await _db.db;
    final rows = await d.rawQuery('''
      SELECT category, COUNT(*) as cnt
      FROM predictions
      WHERE user_id = ?
      GROUP BY category
    ''', [userId]);

    final out = <String, int>{};
    for (final r in rows) {
      out[r['category'] as String] = (r['cnt'] as int?) ?? 0;
    }
    return out;
  }
}