import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'diary_entry.g.dart';

@HiveType(typeId: 0)
class DiaryEntry extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime createdAt;

  @HiveField(2)
  DateTime? updatedAt;

  @HiveField(3)
  String? title;

  @HiveField(4)
  late String content;

  @HiveField(5)
  late List<String> emotions;

  @HiveField(6)
  List<String>? photoUrls;

  @HiveField(7)
  String? weatherInfo;

  @HiveField(8)
  String? location;

  @HiveField(9)
  bool isFavorite;

  @HiveField(10)
  AIFeedback? aiFeedback;

  DiaryEntry({
    String? id,
    DateTime? createdAt,
    this.updatedAt,
    this.title,
    required this.content,
    List<String>? emotions,
    this.photoUrls,
    this.weatherInfo,
    this.location,
    this.isFavorite = false,
    this.aiFeedback,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        emotions = emotions ?? [];

  // Helper methods
  String get displayTitle => title ?? 'Untitled';

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
    }
  }

  String get primaryEmotion => emotions.isNotEmpty ? emotions.first : 'neutral';

  // Copy with method
  DiaryEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? title,
    String? content,
    List<String>? emotions,
    List<String>? photoUrls,
    String? weatherInfo,
    String? location,
    bool? isFavorite,
    AIFeedback? aiFeedback,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      content: content ?? this.content,
      emotions: emotions ?? this.emotions,
      photoUrls: photoUrls ?? this.photoUrls,
      weatherInfo: weatherInfo ?? this.weatherInfo,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
      aiFeedback: aiFeedback ?? this.aiFeedback,
    );
  }
}

@HiveType(typeId: 1)
class AIFeedback extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late DateTime createdAt;

  @HiveField(2)
  late Map<String, double> emotionAnalysis;

  @HiveField(3)
  late String feedbackMessage;

  @HiveField(4)
  List<String>? reflectionQuestions;

  @HiveField(5)
  List<String>? positiveHighlights;

  AIFeedback({
    String? id,
    DateTime? createdAt,
    required this.emotionAnalysis,
    required this.feedbackMessage,
    this.reflectionQuestions,
    this.positiveHighlights,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // Get dominant emotion
  String get dominantEmotion {
    if (emotionAnalysis.isEmpty) return 'neutral';

    return emotionAnalysis.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  double get positivityScore {
    return emotionAnalysis['positive'] ?? 0.0;
  }
}
