import 'package:postgres/postgres.dart';

import '../../core/db_config.dart';

class PostgresDb {
  PostgresDb(this._config);

  final DbConfig _config;
  Connection? _connection;

  Future<Connection> _open() async {
    final existing = _connection;
    if (existing != null && existing.isOpen) return existing;

    final conn = await Connection.open(
      Endpoint(
        host: _config.host,
        port: _config.port,
        database: _config.database,
        username: _config.username,
        password: _config.password,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

    _connection = conn;
    return conn;
  }

  Future<Result> execute(
    Object query, {
    Object? parameters,
    bool ignoreRows = false,
  }) async {
    final conn = await _open();
    return conn.execute(query, parameters: parameters, ignoreRows: ignoreRows);
  }
}
