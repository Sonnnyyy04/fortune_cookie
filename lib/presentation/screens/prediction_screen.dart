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
  static const _breakDuration = Duration(milliseconds: 900);

  bool _revealed = false;
  bool _breaking = false;

  @override
  void initState() {
    super.initState();
    context.read<PredictionController>().reset();
  }

  Future<void> _open() async {
    if (_breaking || _revealed) return;

    final ctrl = context.read<PredictionController>();
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _breaking = true);
    await Future<void>.delayed(_breakDuration);

    try {
      await ctrl.openToday(widget.category);
      if (!mounted) return;
      setState(() => _revealed = true);
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() => _breaking = false);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted && !_revealed) {
        setState(() => _breaking = false);
      }
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _revealed
                ? Column(
                    key: const ValueKey('revealed'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 54,
                        color: Color(0xFF8B6914),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: meta.color.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          ctrl.prediction ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Назад'),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey('closed'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: _breaking ? 1 : 0),
                        duration: _breakDuration,
                        curve: Curves.easeInOutBack,
                        builder: (context, progress, _) {
                          return _CookieBreakVisual(
                            progress: progress,
                            color: meta.color,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _breaking || ctrl.loading
                            ? 'Печенька открывается...'
                            : 'Нажмите, чтобы открыть предсказание',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: (_breaking || ctrl.loading) ? null : _open,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: meta.color,
                        ),
                        child: Text(
                          (_breaking || ctrl.loading)
                              ? 'Открываем...'
                              : 'Открыть печеньку',
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _CookieBreakVisual extends StatelessWidget {
  const _CookieBreakVisual({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final shift = 36 * progress;
    final rotation = 0.35 * progress;

    return SizedBox(
      width: 180,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.translate(
            offset: Offset(-shift, 0),
            child: Transform.rotate(
              angle: -rotation,
              child: ClipRect(
                clipper: const _HalfClipper(leftHalf: true),
                child: Icon(Icons.cookie, size: 120, color: color),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(shift, 0),
            child: Transform.rotate(
              angle: rotation,
              child: ClipRect(
                clipper: const _HalfClipper(leftHalf: false),
                child: Icon(Icons.cookie, size: 120, color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  const _HalfClipper({required this.leftHalf});

  final bool leftHalf;

  @override
  Rect getClip(Size size) {
    if (leftHalf) {
      return Rect.fromLTWH(0, 0, size.width / 2, size.height);
    }
    return Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(covariant _HalfClipper oldClipper) {
    return oldClipper.leftHalf != leftHalf;
  }
}
