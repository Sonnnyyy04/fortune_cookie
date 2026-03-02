import 'package:flutter/foundation.dart';

class DbConfig {
  const DbConfig({
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
  });

  final String host;
  final int port;
  final String database;
  final String username;
  final String password;

  static DbConfig get current {
    final host = defaultTargetPlatform == TargetPlatform.android
        ? const String.fromEnvironment('DB_HOST', defaultValue: '10.0.2.2')
        : const String.fromEnvironment('DB_HOST', defaultValue: 'localhost');

    return DbConfig(
      host: host,
      port:
          int.tryParse(
            const String.fromEnvironment('DB_PORT', defaultValue: '5432'),
          ) ??
          5432,
      database: const String.fromEnvironment(
        'DB_NAME',
        defaultValue: 'fortune_cookie',
      ),
      username: const String.fromEnvironment(
        'DB_USER',
        defaultValue: 'fortune_user',
      ),
      password: const String.fromEnvironment(
        'DB_PASSWORD',
        defaultValue: 'fortune_password',
      ),
    );
  }
}
