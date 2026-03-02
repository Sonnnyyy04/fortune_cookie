import 'package:flutter/material.dart';
import 'dart:math';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  bool _isRevealed = false;
  String _prediction = '';

  // Mock predictions data
  static const Map<String, List<String>> _predictions = {
    'main': [
      'Сегодня удача на вашей стороне!',
      'Впереди вас ждут приятные сюрпризы.',
      'Доверьтесь своей интуиции — она вас не подведет.',
      'Новые возможности уже на пороге.',
      'Сегодня — идеальный день для новых начинаний.',
      'Ваши мечты ближе, чем вы думаете.',
      'Улыбнитесь — вселенная улыбается вам в ответ.',
      'Скоро произойдет что-то удивительное.',
    ],
    'love': [
      'Любовь витает в воздухе — будьте внимательны!',
      'Ваше сердце подскажет правильный путь.',
      'Романтический сюрприз уже в пути.',
      'Сегодня — отличный день для признаний.',
      'Ваша вторая половинка думает о вас прямо сейчас.',
    ],
    'career': [
      'Ваш труд будет вознагражден в ближайшее время.',
      'Новые профессиональные горизонты открываются перед вами.',
      'Коллеги оценят вашу инициативу.',
      'Смелое решение приведет к успеху в карьере.',
      'Важная встреча изменит ваш профессиональный путь.',
    ],
    'health': [
      'Ваше здоровье в ваших руках — берегите себя.',
      'Прогулка на свежем воздухе зарядит вас энергией.',
      'Сегодня — хороший день для занятий спортом.',
      'Обратите внимание на свой режим сна.',
      'Здоровый образ жизни принесет свои плоды совсем скоро.',
    ],
    'finance': [
      'Финансовое решение, принятое сегодня, окажется верным.',
      'Неожиданная прибыль не за горами.',
      'Время для разумных инвестиций.',
      'Экономия сегодня — богатство завтра.',
      'Ваши финансовые планы начинают реализовываться.',
    ],
  };

  static const Map<String, String> _categoryTitles = {
    'main': 'Предсказание дня',
    'love': 'Любовь',
    'career': 'Карьера',
    'health': 'Здоровье',
    'finance': 'Финансы',
  };

  static const Map<String, IconData> _categoryIcons = {
    'main': Icons.cookie,
    'love': Icons.favorite,
    'career': Icons.work,
    'health': Icons.health_and_safety,
    'finance': Icons.attach_money,
  };

  static const Map<String, Color> _categoryColors = {
    'main': Color(0xFFD4A24E),
    'love': Color(0xFFE91E63),
    'career': Color(0xFF2196F3),
    'health': Color(0xFF4CAF50),
    'finance': Color(0xFFFF9800),
  };

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _revealPrediction(String category) {
    final predictions = _predictions[category] ?? _predictions['main']!;
    final random = Random();
    _prediction = predictions[random.nextInt(predictions.length)];

    _shakeController.forward().then((_) {
      setState(() {
        _isRevealed = true;
      });
      _fadeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final category =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'main';
    final title = _categoryTitles[category] ?? 'Предсказание';
    final icon = _categoryIcons[category] ?? Icons.cookie;
    final color = _categoryColors[category] ?? const Color(0xFFD4A24E);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8E7),
              Color(0xFFFEFCF3),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isRevealed) ...[
              // Cookie before reveal
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      sin(_shakeAnimation.value * pi * 8) * 10,
                      0,
                    ),
                    child: Transform.rotate(
                      angle: sin(_shakeAnimation.value * pi * 6) * 0.1,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 3),
                  ),
                  child: Icon(icon, size: 80, color: color),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Нажмите, чтобы открыть\nпредсказание',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF795548),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _revealPrediction(category),
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Открыть печеньку'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ] else ...[
              // Revealed prediction
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Broken cookie icon
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.rotate(
                              angle: -0.2,
                              child:
                                  Icon(Icons.cookie, size: 50, color: color),
                            ),
                            const SizedBox(width: 8),
                            Transform.rotate(
                              angle: 0.2,
                              child:
                                  Icon(Icons.cookie, size: 50, color: color),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Prediction text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.format_quote,
                              color: color,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _prediction,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3E2723),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Icon(
                              Icons.format_quote,
                              color: color,
                              size: 32,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Назад'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: color,
                            side: BorderSide(color: color),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
