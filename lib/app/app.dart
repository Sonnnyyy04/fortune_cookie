import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/db/app_db.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/prediction_repository_impl.dart';
import '../data/session/session_store.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/prediction_repository.dart';
import '../domain/services/fortune_service.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/history_controller.dart';
import '../presentation/controllers/prediction_controller.dart';
import '../presentation/controllers/profile_controller.dart';
import 'router.dart';
import 'theme.dart';

class FortuneCookieApp extends StatelessWidget {
  const FortuneCookieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDb>(create: (_) => AppDb.instance),
        Provider<SessionStore>(create: (_) => SessionStore()),

        Provider<AuthRepository>(
          create: (ctx) => AuthRepositoryImpl(ctx.read<AppDb>()),
        ),
        Provider<PredictionRepository>(
          create: (ctx) => PredictionRepositoryImpl(ctx.read<AppDb>()),
        ),

        Provider<FortuneService>(
          create: (ctx) => FortuneService(
            predictionRepository: ctx.read<PredictionRepository>(),
          ),
        ),

        ChangeNotifierProvider<AuthController>(
          create: (ctx) => AuthController(
            authRepository: ctx.read<AuthRepository>(),
            sessionStore: ctx.read<SessionStore>(),
          ),
        ),
        ChangeNotifierProvider<PredictionController>(
          create: (ctx) => PredictionController(
            fortuneService: ctx.read<FortuneService>(),
            sessionStore: ctx.read<SessionStore>(),
          ),
        ),
        ChangeNotifierProvider<HistoryController>(
          create: (ctx) => HistoryController(
            predictionRepository: ctx.read<PredictionRepository>(),
            sessionStore: ctx.read<SessionStore>(),
          ),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (ctx) => ProfileController(
            authRepository: ctx.read<AuthRepository>(),
            predictionRepository: ctx.read<PredictionRepository>(),
            sessionStore: ctx.read<SessionStore>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Fortune Cookie',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}