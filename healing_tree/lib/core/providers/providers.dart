import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/services/database_service.dart';
import '../../shared/services/ai_service.dart';
import '../../features/diary/data/repositories/diary_repository.dart';
import '../../features/settings/data/repositories/settings_repository.dart';

// Database Service Provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

// AI Service Provider
final aiServiceProvider = Provider<AIService>((ref) {
  // TODO: Get API key from environment or secure storage
  const apiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );
  return AIService(apiKey: apiKey);
});

// Repository Providers
final diaryRepositoryProvider = Provider<DiaryRepository>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return DiaryRepository(databaseService: databaseService);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return SettingsRepository(databaseService: databaseService);
});
