import 'package:tourism_app/data/models/place_model.dart';

enum CrowdLevel { low, medium, high }

class CrowdPrediction {
  final int crowdScore;
  final CrowdLevel level;
  final double confidence;
  final String explanation;

  const CrowdPrediction({
    required this.crowdScore,
    required this.level,
    required this.confidence,
    required this.explanation,
  });

  String get levelLabel {
    switch (level) {
      case CrowdLevel.low:
        return 'Low';
      case CrowdLevel.medium:
        return 'Medium';
      case CrowdLevel.high:
        return 'High';
    }
  }
}

class CrowdPredictorService {
  CrowdPrediction predict({
    required PlaceModel place,
    required DateTime dateTime,
    bool isHoliday = false,
    String weatherCondition = 'clear',
  }) {
    double score = 30.0;

    final weekday = dateTime.weekday;
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      score += 25;
    } else if (weekday == DateTime.friday) {
      score += 10;
    }

    final hour = dateTime.hour;
    if (hour >= 10 && hour <= 12) score += 20;
    if (hour >= 14 && hour <= 17) score += 15;
    if (hour >= 18 && hour <= 20) score += 10;
    if (hour < 8 || hour > 21) score -= 20;

    if (isHoliday) score += 20;

    score += place.popularityScore * 2;

    if (weatherCondition == 'rain') score -= 15;
    if (weatherCondition == 'storm') score -= 30;

    final month = dateTime.month;
    if (month >= 3 && month <= 5) score += 15;
    if (month >= 9 && month <= 11) score += 12;
    if (month == 12 || month == 1) score -= 5;

    score = score.clamp(0, 100);

    final level = score >= 70
        ? CrowdLevel.high
        : score >= 40
            ? CrowdLevel.medium
            : CrowdLevel.low;

    String explanation;
    if (level == CrowdLevel.high) {
      explanation = 'Expect large crowds. Consider visiting earlier or later.';
    } else if (level == CrowdLevel.medium) {
      explanation = 'Moderate crowd expected. Arrive early to avoid queues.';
    } else {
      explanation = 'Light crowds expected. Great time to visit!';
    }

    return CrowdPrediction(
      crowdScore: score.round(),
      level: level,
      confidence: 0.75,
      explanation: explanation,
    );
  }
}
