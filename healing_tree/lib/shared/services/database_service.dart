import 'package:hive_flutter/hive_flutter.dart';
import '../models/diary_entry.dart';
import '../models/user_settings.dart';
import '../../core/constants/app_constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Box<DiaryEntry>? _diaryBox;
  Box<UserSettings>? _settingsBox;

  // Initialize Hive and register adapters
  Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DiaryEntryAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(AIFeedbackAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserSettingsAdapter());
    }

    // Open boxes
    _diaryBox = await Hive.openBox<DiaryEntry>(AppConstants.diaryBox);
    _settingsBox = await Hive.openBox<UserSettings>(AppConstants.settingsBox);
  }

  // Getters for boxes
  Box<DiaryEntry> get diaryBox {
    if (_diaryBox == null || !_diaryBox!.isOpen) {
      throw Exception('Diary box not initialized');
    }
    return _diaryBox!;
  }

  Box<UserSettings> get settingsBox {
    if (_settingsBox == null || !_settingsBox!.isOpen) {
      throw Exception('Settings box not initialized');
    }
    return _settingsBox!;
  }

  // Close all boxes
  Future<void> close() async {
    await _diaryBox?.close();
    await _settingsBox?.close();
  }

  // Clear all data (for testing or reset)
  Future<void> clearAll() async {
    await _diaryBox?.clear();
    await _settingsBox?.clear();
  }
}
