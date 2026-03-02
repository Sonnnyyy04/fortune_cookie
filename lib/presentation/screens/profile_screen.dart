import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/router.dart';
import '../../core/categories.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ProfileController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Личный кабинет'), automaticallyImplyLeading: false),
      body: ctrl.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.person, size: 84, color: Color(0xFF8B6914)),
            const SizedBox(height: 8),
            Text(ctrl.user?.username ?? 'Пользователь', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(ctrl.user?.email ?? '', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Статистика', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),

            ...FortuneCategories.list.map((c) {
              final count = ctrl.stats[c.code] ?? 0;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(c.icon, color: c.color),
                title: Text(c.title),
                trailing: Text('$count', style: TextStyle(fontWeight: FontWeight.bold, color: c.color)),
              );
            }),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await context.read<AuthController>().logout();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, AppRoutes.auth);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Выйти из аккаунта'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}