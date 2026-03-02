import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user data
    const username = 'Пользователь';
    const email = 'user@example.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Личный кабинет'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // User avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A24E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3E2723).withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              email,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF795548),
              ),
            ),
            const SizedBox(height: 32),

            // Statistics
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Статистика',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Всего',
                    '12',
                    Icons.cookie,
                    const Color(0xFFD4A24E),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Любовь',
                    '3',
                    Icons.favorite,
                    const Color(0xFFE91E63),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Карьера',
                    '4',
                    Icons.work,
                    const Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Здоровье',
                    '2',
                    Icons.health_and_safety,
                    const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Финансы',
                    '3',
                    Icons.attach_money,
                    const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 32),

            // Settings section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Настройки',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildSettingsTile(
              icon: Icons.person_outline,
              title: 'Редактировать профиль',
              onTap: () {
                // TODO: Implement in lab3-5
              },
            ),
            _buildSettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Уведомления',
              onTap: () {
                // TODO: Implement in lab3-5
              },
            ),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'О приложении',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Печенька с предсказанием',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(
                    Icons.cookie,
                    size: 48,
                    color: Color(0xFFD4A24E),
                  ),
                  children: [
                    const Text(
                        'Получайте ежедневные предсказания от волшебной печеньки!'),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Implement actual logout in lab3-5
                  Navigator.pushReplacementNamed(context, '/auth');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Выйти из аккаунта'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF795548),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF8B6914)),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF3E2723)),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Color(0xFFBDBDBD),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
