import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const FortuneCookieApp());
}

class FortuneCookieApp extends StatelessWidget {
  const FortuneCookieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fortune Cookie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B6914),
          primary: const Color(0xFF8B6914),
          secondary: const Color(0xFFFFF8E7),
          surface: const Color(0xFFFEFCF3),
        ),
        scaffoldBackgroundColor: const Color(0xFFFEFCF3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B6914),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B6914),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3E2723),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF3E2723),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
      },
    );
  }
}
