import 'package:flutter/material.dart';

class MyPredictionsScreen extends StatefulWidget {
  const MyPredictionsScreen({super.key});

  @override
  State<MyPredictionsScreen> createState() => _MyPredictionsScreenState();
}

class _MyPredictionsScreenState extends State<MyPredictionsScreen> {
  String _selectedFilter = 'all';

  // Mock data for predictions history
  final List<Map<String, dynamic>> _predictions = [
    {
      'text': 'Сегодня удача на вашей стороне!',
      'category': 'main',
      'date': '2026-03-02',
    },
    {
      'text': 'Любовь витает в воздухе — будьте внимательны!',
      'category': 'love',
      'date': '2026-03-02',
    },
    {
      'text': 'Ваш труд будет вознагражден в ближайшее время.',
      'category': 'career',
      'date': '2026-03-01',
    },
    {
      'text': 'Прогулка на свежем воздухе зарядит вас энергией.',
      'category': 'health',
      'date': '2026-03-01',
    },
    {
      'text': 'Неожиданная прибыль не за горами.',
      'category': 'finance',
      'date': '2026-02-28',
    },
    {
      'text': 'Ваши мечты ближе, чем вы думаете.',
      'category': 'main',
      'date': '2026-02-28',
    },
  ];

  static const Map<String, String> _categoryTitles = {
    'main': 'Основное',
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

  List<Map<String, dynamic>> get _filteredPredictions {
    if (_selectedFilter == 'all') return _predictions;
    return _predictions
        .where((p) => p['category'] == _selectedFilter)
        .toList();
  }

  void _deletePrediction(int index) {
    final prediction = _filteredPredictions[index];
    setState(() {
      _predictions.remove(prediction);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Предсказание удалено'),
        action: SnackBarAction(
          label: 'Отмена',
          onPressed: () {
            setState(() {
              _predictions.insert(
                  _predictions.length > index ? index : _predictions.length,
                  prediction);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои предсказания'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('all', 'Все', Icons.select_all),
                const SizedBox(width: 8),
                ..._categoryTitles.entries.map((e) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildFilterChip(
                        e.key,
                        e.value,
                        _categoryIcons[e.key]!,
                      ),
                    )),
              ],
            ),
          ),

          // Predictions list
          Expanded(
            child: _filteredPredictions.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cookie_outlined,
                          size: 64,
                          color: Color(0xFFBDBDBD),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Предсказаний пока нет',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPredictions.length,
                    itemBuilder: (context, index) {
                      final prediction = _filteredPredictions[index];
                      final category = prediction['category'] as String;
                      final color = _categoryColors[category] ??
                          const Color(0xFFD4A24E);
                      final icon = _categoryIcons[category] ?? Icons.cookie;
                      final categoryTitle =
                          _categoryTitles[category] ?? 'Основное';

                      return Dismissible(
                        key: ValueKey(prediction),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _deletePrediction(index),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
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
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(icon, color: color, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prediction['text'] as String,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF3E2723),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          categoryTitle,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          prediction['date'] as String,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9E9E9E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Color(0xFFBDBDBD),
                                ),
                                onPressed: () => _deletePrediction(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? Colors.white : const Color(0xFF795548),
          ),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: const Color(0xFF8B6914),
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF795548),
        fontSize: 13,
      ),
      backgroundColor: const Color(0xFFFFF8E7),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
    );
  }
}
