import '../../core/errors.dart';
import '../../domain/entities/prediction.dart';
import '../../domain/repository/prediction_repository.dart';
import '../db/postgres_db.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  PredictionRepositoryImpl(this._db);

  final PostgresDb _db;

  int _asInt(Object? value) {
    if (value is int) return value;
    if (value is BigInt) return value.toInt();
    if (value is num) return value.toInt();
    return int.parse(value.toString());
  }

  String _asString(Object? value) => value?.toString() ?? '';

  Prediction _mapRow(List<Object?> row) {
    return Prediction(
      id: _asInt(row[0]),
      userId: _asInt(row[1]),
      category: _asString(row[2]),
      text: _asString(row[3]),
      createdAtIso: _asString(row[4]),
      dayKey: _asString(row[5]),
    );
  }

  @override
  Future<Prediction?> getPredictionForDay({
    required int userId,
    required String dayKey,
    required String category,
  }) async {
    final result = await _db.execute(
      '''
      SELECT
        up.id,
        up.user_id,
        up.category,
        pt.text,
        to_char(up.created_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') AS created_at_iso,
        to_char(up.day_key, 'YYYY-MM-DD') AS day_key
      FROM user_predictions up
      JOIN prediction_templates pt ON pt.id = up.template_id
      WHERE up.user_id = \$1
        AND up.day_key = \$2::date
        AND up.category = \$3
      ORDER BY up.created_at DESC
      LIMIT 1
      ''',
      parameters: [userId, dayKey, category],
    );

    if (result.isEmpty) return null;
    return _mapRow(result.first);
  }

  @override
  Future<int> countPredictionsForDay({
    required int userId,
    required String dayKey,
  }) async {
    final result = await _db.execute(
      '''
      SELECT COUNT(*)
      FROM user_predictions
      WHERE user_id = \$1
        AND day_key = \$2::date
      ''',
      parameters: [userId, dayKey],
    );

    if (result.isEmpty) return 0;
    return _asInt(result.first[0]);
  }

  @override
  Future<int> insertPrediction({
    required int userId,
    required String category,
    required String createdAtIso,
    required String dayKey,
  }) async {
    final result = await _db.execute(
      '''
      WITH selected_template AS (
        SELECT id
        FROM prediction_templates
        WHERE category = \$1
          AND is_active = TRUE
        ORDER BY random()
        LIMIT 1
      ),
      existing AS (
        SELECT id
        FROM user_predictions
        WHERE user_id = \$2
          AND day_key = \$4::date
          AND category = \$1
        LIMIT 1
      ),
      inserted AS (
        INSERT INTO user_predictions(user_id, template_id, category, created_at, day_key)
        SELECT \$2, st.id, \$1, \$3::timestamptz, \$4::date
        FROM selected_template st
        WHERE NOT EXISTS (SELECT 1 FROM existing)
        RETURNING id
      )
      SELECT id FROM inserted
      UNION ALL
      SELECT id FROM existing
      LIMIT 1
      ''',
      parameters: [category, userId, createdAtIso, dayKey],
    );

    if (result.isEmpty) {
      throw AppException('Для выбранной категории нет предсказаний.');
    }
    return _asInt(result.first[0]);
  }

  @override
  Future<List<Prediction>> listPredictions({
    required int userId,
    String? category,
  }) async {
    final result = category == null
        ? await _db.execute(
            '''
            SELECT
              up.id,
              up.user_id,
              up.category,
              pt.text,
              to_char(up.created_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') AS created_at_iso,
              to_char(up.day_key, 'YYYY-MM-DD') AS day_key
            FROM user_predictions up
            JOIN prediction_templates pt ON pt.id = up.template_id
            WHERE up.user_id = \$1
            ORDER BY up.created_at DESC
            ''',
            parameters: [userId],
          )
        : await _db.execute(
            '''
            SELECT
              up.id,
              up.user_id,
              up.category,
              pt.text,
              to_char(up.created_at AT TIME ZONE 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"') AS created_at_iso,
              to_char(up.day_key, 'YYYY-MM-DD') AS day_key
            FROM user_predictions up
            JOIN prediction_templates pt ON pt.id = up.template_id
            WHERE up.user_id = \$1
              AND up.category = \$2
            ORDER BY up.created_at DESC
            ''',
            parameters: [userId, category],
          );

    return result.map(_mapRow).toList();
  }

  @override
  Future<void> deletePrediction(int id) async {
    await _db.execute(
      'DELETE FROM user_predictions WHERE id = \$1',
      parameters: [id],
      ignoreRows: true,
    );
  }

  @override
  Future<Map<String, int>> statsByCategory(int userId) async {
    final result = await _db.execute(
      '''
      SELECT category, COUNT(*)
      FROM user_predictions
      WHERE user_id = \$1
      GROUP BY category
      ''',
      parameters: [userId],
    );

    final out = <String, int>{};
    for (final row in result) {
      out[_asString(row[0])] = _asInt(row[1]);
    }
    return out;
  }
}
