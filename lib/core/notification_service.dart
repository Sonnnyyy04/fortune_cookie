import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: settings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();

    _isInitialized = true;
  }

  Future<void> showPredictionOpened({
    required String categoryTitle,
    required String predictionText,
  }) async {
    if (!_isInitialized) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'fortune_predictions',
        'Предсказания',
        channelDescription: 'Уведомления о новых предсказаниях',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Новое предсказание: $categoryTitle',
      body: predictionText,
      notificationDetails: details,
    );
  }
}
