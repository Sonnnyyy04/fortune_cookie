class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class NotLoggedInException extends AppException {
  NotLoggedInException() : super('Пользователь не авторизован');
}

class DailyLimitReachedException extends AppException {
  DailyLimitReachedException()
      : super('Лимит на сегодня исчерпан (максимум 4 предсказания в день).');
}