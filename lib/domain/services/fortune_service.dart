import 'dart:math';

import '../../core/date_utils.dart';
import '../../core/errors.dart';
import '../repository/prediction_repository.dart';

class FortuneService {
  FortuneService({required PredictionRepository predictionRepository})
      : _repo = predictionRepository;

  final PredictionRepository _repo;

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

  Future<String> openTodayPrediction({
    required int userId,
    required String category,
  }) async {
    final now = DateTime.now();
    final dayKey = DateUtilsX.dayKey(now);

    final existing = await _repo.getPredictionForDay(
      userId: userId,
      dayKey: dayKey,
      category: category,
    );
    if (existing != null) return existing.text;

    final count = await _repo.countPredictionsForDay(userId: userId, dayKey: dayKey);
    if (count >= 4) throw DailyLimitReachedException();

    final list = _predictions[category] ?? _predictions['main']!;
    final text = list[Random().nextInt(list.length)];

    await _repo.insertPrediction(
      userId: userId,
      category: category,
      text: text,
      createdAtIso: now.toIso8601String(),
      dayKey: dayKey,
    );

    return text;
  }
}