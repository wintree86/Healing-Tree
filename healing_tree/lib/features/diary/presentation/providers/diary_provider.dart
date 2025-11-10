import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/diary_entry.dart';
import '../../../../core/providers/providers.dart';
import '../../data/repositories/diary_repository.dart';

// Diary List State Notifier
class DiaryListNotifier extends StateNotifier<AsyncValue<List<DiaryEntry>>> {
  final DiaryRepository _repository;

  DiaryListNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDiaries();
  }

  Future<void> loadDiaries() async {
    state = const AsyncValue.loading();
    try {
      final diaries = _repository.getAllDiaries();
      state = AsyncValue.data(diaries);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addDiary(DiaryEntry diary) async {
    await _repository.createDiary(diary);
    await loadDiaries();
  }

  Future<void> updateDiary(DiaryEntry diary) async {
    await _repository.updateDiary(diary);
    await loadDiaries();
  }

  Future<void> deleteDiary(String id) async {
    await _repository.deleteDiary(id);
    await loadDiaries();
  }

  Future<void> toggleFavorite(DiaryEntry diary) async {
    final updated = diary.copyWith(isFavorite: !diary.isFavorite);
    await updateDiary(updated);
  }

  List<DiaryEntry> searchDiaries(String query) {
    return _repository.searchDiaries(query);
  }

  List<DiaryEntry> filterByEmotion(String emotion) {
    return _repository.getDiariesByEmotion(emotion);
  }
}

// Diary List Provider
final diaryListProvider =
    StateNotifierProvider<DiaryListNotifier, AsyncValue<List<DiaryEntry>>>(
  (ref) {
    final repository = ref.watch(diaryRepositoryProvider);
    return DiaryListNotifier(repository);
  },
);

// Single Diary Provider
final diaryProvider =
    FutureProvider.family<DiaryEntry?, String>((ref, id) async {
  final repository = ref.watch(diaryRepositoryProvider);
  return repository.getDiaryById(id);
});

// Recent Diaries Provider (last 7 days)
final recentDiariesProvider = Provider<List<DiaryEntry>>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  return repository.getRecentDiaries(days: 7);
});

// Favorite Diaries Provider
final favoriteDiariesProvider = Provider<List<DiaryEntry>>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  return repository.getFavoriteDiaries();
});

// Has Diary Today Provider
final hasDiaryTodayProvider = Provider<bool>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  return repository.hasDiaryForToday();
});

// Diary Statistics Provider
final diaryStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final repository = ref.watch(diaryRepositoryProvider);
  return {
    'total': repository.getTotalDiaryCount(),
    'emotions': repository.getEmotionStatistics(),
  };
});
