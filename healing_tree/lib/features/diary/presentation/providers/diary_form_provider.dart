import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/diary_entry.dart';
import '../../../../core/providers/providers.dart';
import 'diary_provider.dart';

// Diary Form State
class DiaryFormState {
  final String? id;
  final String? title;
  final String content;
  final List<String> emotions;
  final List<String> photoUrls;
  final bool isLoading;
  final bool isGeneratingAI;

  DiaryFormState({
    this.id,
    this.title,
    this.content = '',
    this.emotions = const [],
    this.photoUrls = const [],
    this.isLoading = false,
    this.isGeneratingAI = false,
  });

  DiaryFormState copyWith({
    String? id,
    String? title,
    String? content,
    List<String>? emotions,
    List<String>? photoUrls,
    bool? isLoading,
    bool? isGeneratingAI,
  }) {
    return DiaryFormState(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      emotions: emotions ?? this.emotions,
      photoUrls: photoUrls ?? this.photoUrls,
      isLoading: isLoading ?? this.isLoading,
      isGeneratingAI: isGeneratingAI ?? this.isGeneratingAI,
    );
  }

  bool get isValid => content.trim().isNotEmpty;
}

// Diary Form Notifier
class DiaryFormNotifier extends StateNotifier<DiaryFormState> {
  final Ref _ref;

  DiaryFormNotifier(this._ref) : super(DiaryFormState());

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setContent(String content) {
    state = state.copyWith(content: content);
  }

  void addEmotion(String emotion) {
    if (!state.emotions.contains(emotion)) {
      state = state.copyWith(emotions: [...state.emotions, emotion]);
    }
  }

  void removeEmotion(String emotion) {
    state = state.copyWith(
      emotions: state.emotions.where((e) => e != emotion).toList(),
    );
  }

  void toggleEmotion(String emotion) {
    if (state.emotions.contains(emotion)) {
      removeEmotion(emotion);
    } else {
      addEmotion(emotion);
    }
  }

  void addPhoto(String url) {
    state = state.copyWith(photoUrls: [...state.photoUrls, url]);
  }

  void removePhoto(String url) {
    state = state.copyWith(
      photoUrls: state.photoUrls.where((u) => u != url).toList(),
    );
  }

  Future<bool> saveDiary() async {
    if (!state.isValid) return false;

    state = state.copyWith(isLoading: true);

    try {
      final diary = DiaryEntry(
        id: state.id,
        title: state.title?.isNotEmpty == true ? state.title : null,
        content: state.content,
        emotions: state.emotions,
        photoUrls: state.photoUrls.isNotEmpty ? state.photoUrls : null,
      );

      // Generate AI feedback if content is substantial
      if (state.content.length > 50) {
        await _generateAIFeedback(diary);
      }

      // Save to repository
      final diaryList = _ref.read(diaryListProvider.notifier);
      if (state.id != null) {
        await diaryList.updateDiary(diary);
      } else {
        await diaryList.addDiary(diary);
      }

      reset();
      return true;
    } catch (e) {
      debugPrint('Error saving diary: $e');
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<void> _generateAIFeedback(DiaryEntry diary) async {
    state = state.copyWith(isGeneratingAI: true);

    try {
      final aiService = _ref.read(aiServiceProvider);
      final feedback = await aiService.analyzeDiary(diary.content);

      // Update diary with AI feedback
      final updatedDiary = diary.copyWith(aiFeedback: feedback);
      final diaryList = _ref.read(diaryListProvider.notifier);

      if (state.id != null) {
        await diaryList.updateDiary(updatedDiary);
      } else {
        await diaryList.addDiary(updatedDiary);
      }
    } catch (e) {
      debugPrint('Error generating AI feedback: $e');
      // Continue without AI feedback
    } finally {
      state = state.copyWith(isGeneratingAI: false);
    }
  }

  void loadDiary(DiaryEntry diary) {
    state = DiaryFormState(
      id: diary.id,
      title: diary.title,
      content: diary.content,
      emotions: diary.emotions,
      photoUrls: diary.photoUrls ?? [],
    );
  }

  void reset() {
    state = DiaryFormState();
  }
}

// Diary Form Provider
final diaryFormProvider =
    StateNotifierProvider<DiaryFormNotifier, DiaryFormState>((ref) {
  return DiaryFormNotifier(ref);
});
