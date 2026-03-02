import 'package:flutter/material.dart';

import '../core/categories.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/auth_screen.dart';
import '../presentation/screens/main_shell.dart';
import '../presentation/screens/prediction_screen.dart';

class AppRoutes {
  static const splash = '/';
  static const auth = '/auth';
  static const home = '/home';
  static const prediction = '/prediction';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainShell());
      case AppRoutes.prediction:
        return MaterialPageRoute(
          builder: (_) => PredictionScreen(
            category: (settings.arguments as String?) ?? FortuneCategoryCodes.main,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}