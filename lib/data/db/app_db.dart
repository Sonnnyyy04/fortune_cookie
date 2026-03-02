import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();

  Database? _db;

  Future<Database> get db async {
    final existing = _db;
    if (existing != null) return existing;

    final base = await getDatabasesPath();
    final path = p.join(base, 'fortune_cookie.db');

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE predictions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            category TEXT NOT NULL,
            text TEXT NOT NULL,
            created_at TEXT NOT NULL,
            day_key TEXT NOT NULL,
            FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
          );
        ''');

        await db.execute('''
          CREATE UNIQUE INDEX idx_pred_user_day_cat
          ON predictions(user_id, day_key, category);
        ''');

        await db.execute('''
          CREATE INDEX idx_pred_user_day
          ON predictions(user_id, day_key);
        ''');
      },
    );

    _db = database;
    return database;
  }
}