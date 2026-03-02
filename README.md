# Fortune Cookie (Flutter + PostgreSQL)

This project uses direct PostgreSQL access from Flutter (no backend service).

## Start database (Docker)
```bash
docker compose up -d
docker compose ps
```

Only one container is used:
- PostgreSQL: `localhost:5432`

## Run Flutter app
```bash
flutter pub get
flutter run
```

Default DB credentials in app:
- `DB_HOST`: Android emulator `10.0.2.2`, desktop `localhost`
- `DB_PORT`: `5432`
- `DB_NAME`: `fortune_cookie`
- `DB_USER`: `fortune_user`
- `DB_PASSWORD`: `fortune_password`

Override if needed:
```bash
flutter run --dart-define=DB_HOST=10.0.2.2 --dart-define=DB_PORT=5432 --dart-define=DB_NAME=fortune_cookie --dart-define=DB_USER=fortune_user --dart-define=DB_PASSWORD=fortune_password
```

## Checks
```bash
flutter analyze
flutter test
```

## Database schema
Schema is initialized from [docker/init/01_schema.sql](docker/init/01_schema.sql):
- `users`
- `prediction_templates`
- `user_predictions`

run codex resume 019cae89-3e73-78c2-a053-564160523f39