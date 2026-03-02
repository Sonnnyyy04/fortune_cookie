import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/categories.dart';
import '../../core/errors.dart';
import '../controllers/prediction_controller.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key, required this.category});
  final String category;

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    context.read<PredictionController>().reset();
  }

  Future<void> _open() async {
    final ctrl = context.read<PredictionController>();
    try {
      await ctrl.openToday(widget.category);
      setState(() => _revealed = true);
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final meta = FortuneCategories.byCode(widget.category);
    final ctrl = context.watch<PredictionController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(meta.title),
        backgroundColor: meta.color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ctrl.loading
              ? const CircularProgressIndicator()
              : !_revealed
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(meta.icon, size: 96, color: meta.color),
              const SizedBox(height: 20),
              const Text('Нажмите, чтобы открыть предсказание', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _open,
                style: ElevatedButton.styleFrom(backgroundColor: meta.color),
                child: const Text('Открыть печеньку'),
              ),
            ],
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cookie, size: 72, color: meta.color),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: meta.color.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  ctrl.prediction ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, height: 1.4),
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Назад'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}