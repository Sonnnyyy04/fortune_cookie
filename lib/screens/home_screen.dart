import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Печенька с предсказанием',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E2723),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Выберите предсказание на сегодня',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF795548),
                  ),
                ),
                const SizedBox(height: 32),

                // Main cookie button
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/prediction',
                        arguments: 'main');
                  },
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A24E),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF3E2723).withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cookie,
                          size: 80,
                          color: Color(0xFF3E2723),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Получить',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        Text(
                          'предсказание',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5D4037),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Categories section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Категории',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: [
                    _buildCategoryCard(
                      context,
                      icon: Icons.favorite,
                      title: 'Любовь',
                      color: const Color(0xFFE91E63),
                      category: 'love',
                    ),
                    _buildCategoryCard(
                      context,
                      icon: Icons.work,
                      title: 'Карьера',
                      color: const Color(0xFF2196F3),
                      category: 'career',
                    ),
                    _buildCategoryCard(
                      context,
                      icon: Icons.health_and_safety,
                      title: 'Здоровье',
                      color: const Color(0xFF4CAF50),
                      category: 'health',
                    ),
                    _buildCategoryCard(
                      context,
                      icon: Icons.attach_money,
                      title: 'Финансы',
                      color: const Color(0xFFFF9800),
                      category: 'finance',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required String category,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/prediction', arguments: category);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
