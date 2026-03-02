class Prediction {
  final int id;
  final int userId;
  final String category;
  final String text;
  final String createdAtIso;
  final String dayKey;

  const Prediction({
    required this.id,
    required this.userId,
    required this.category,
    required this.text,
    required this.createdAtIso,
    required this.dayKey,
  });
}