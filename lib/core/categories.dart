import 'package:flutter/material.dart';

class FortuneCategoryCodes {
  static const main = 'main';
  static const love = 'love';
  static const career = 'career';
  static const health = 'health';
  static const finance = 'finance';

  static const all = 'all';

  static const List<String> values = [main, love, career, health, finance];
}

class FortuneCategoryMeta {
  final String code;
  final String title;
  final IconData icon;
  final Color color;

  const FortuneCategoryMeta({
    required this.code,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class FortuneCategories {
  static const List<FortuneCategoryMeta> list = [
    FortuneCategoryMeta(
      code: FortuneCategoryCodes.main,
      title: 'Предсказание дня',
      icon: Icons.cookie,
      color: Color(0xFFD4A24E),
    ),
    FortuneCategoryMeta(
      code: FortuneCategoryCodes.love,
      title: 'Любовь',
      icon: Icons.favorite,
      color: Color(0xFFE91E63),
    ),
    FortuneCategoryMeta(
      code: FortuneCategoryCodes.career,
      title: 'Карьера',
      icon: Icons.work,
      color: Color(0xFF2196F3),
    ),
    FortuneCategoryMeta(
      code: FortuneCategoryCodes.health,
      title: 'Здоровье',
      icon: Icons.health_and_safety,
      color: Color(0xFF4CAF50),
    ),
    FortuneCategoryMeta(
      code: FortuneCategoryCodes.finance,
      title: 'Финансы',
      icon: Icons.attach_money,
      color: Color(0xFFFF9800),
    ),
  ];

  static FortuneCategoryMeta byCode(String code) {
    return list.firstWhere(
          (c) => c.code == code,
      orElse: () => list.first,
    );
  }
}