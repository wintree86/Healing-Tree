import 'package:hive/hive.dart';
import '../../../../shared/models/diary_entry.dart';
import '../../../../shared/services/database_service.dart';

class DiaryRepository {
  final DatabaseService _databaseService;

  DiaryRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  Box<DiaryEntry> get _box => _databaseService.diaryBox;

  // Create
  Future<void> createDiary(DiaryEntry diary) async {
    await _box.put(diary.id, diary);
  }

  // Read all
  List<DiaryEntry> getAllDiaries() {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Read by ID
  DiaryEntry? getDiaryById(String id) {
    return _box.get(id);
  }

  // Read by date range
  List<DiaryEntry> getDiariesByDateRange(DateTime start, DateTime end) {
    return _box.values
        .where((diary) =>
            diary.createdAt.isAfter(start) && diary.createdAt.isBefore(end))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Read by emotion
  List<DiaryEntry> getDiariesByEmotion(String emotion) {
    return _box.values
        .where((diary) => diary.emotions.contains(emotion))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Read favorites
  List<DiaryEntry> getFavoriteDiaries() {
    return _box.values.where((diary) => diary.isFavorite).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Update
  Future<void> updateDiary(DiaryEntry diary) async {
    diary.updatedAt = DateTime.now();
    await _box.put(diary.id, diary);
  }

  // Delete
  Future<void> deleteDiary(String id) async {
    await _box.delete(id);
  }

  // Search
  List<DiaryEntry> searchDiaries(String query) {
    final lowerQuery = query.toLowerCase();
    return _box.values
        .where((diary) =>
            diary.content.toLowerCase().contains(lowerQuery) ||
            (diary.title?.toLowerCase().contains(lowerQuery) ?? false))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Statistics
  Map<String, int> getEmotionStatistics() {
    final stats = <String, int>{};
    for (final diary in _box.values) {
      for (final emotion in diary.emotions) {
        stats[emotion] = (stats[emotion] ?? 0) + 1;
      }
    }
    return stats;
  }

  int getTotalDiaryCount() {
    return _box.length;
  }

  int getDiaryCountByMonth(int year, int month) {
    return _box.values
        .where((diary) =>
            diary.createdAt.year == year && diary.createdAt.month == month)
        .length;
  }

  // Get recent diaries (last N days)
  List<DiaryEntry> getRecentDiaries({int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _box.values
        .where((diary) => diary.createdAt.isAfter(cutoffDate))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Check if diary exists for today
  bool hasDiaryForToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return _box.values.any((diary) =>
        diary.createdAt.isAfter(today) && diary.createdAt.isBefore(tomorrow));
  }

  // Get diary for specific date
  DiaryEntry? getDiaryForDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    final nextDay = targetDate.add(const Duration(days: 1));

    final diaries = _box.values
        .where((diary) =>
            diary.createdAt.isAfter(targetDate) &&
            diary.createdAt.isBefore(nextDay))
        .toList();

    return diaries.isNotEmpty ? diaries.first : null;
  }

  // Stream for real-time updates
  Stream<List<DiaryEntry>> watchAllDiaries() {
    return _box.watch().map((_) => getAllDiaries());
  }
}
