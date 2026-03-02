import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(FortuneCookieApp(notificationService: notificationService));
}
