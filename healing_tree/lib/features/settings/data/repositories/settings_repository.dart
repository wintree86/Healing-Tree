import 'package:flutter/material.dart';
import '../../../../shared/models/user_settings.dart';
import '../../../../shared/services/database_service.dart';

class SettingsRepository {
  final DatabaseService _databaseService;
  static const String _settingsKey = 'user_settings';

  SettingsRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  // Get settings
  UserSettings getSettings() {
    final settings = _databaseService.settingsBox.get(_settingsKey);
    if (settings == null) {
      // Create default settings
      final defaultSettings = UserSettings(userId: 'default_user');
      saveSettings(defaultSettings);
      return defaultSettings;
    }
    return settings;
  }

  // Save settings
  Future<void> saveSettings(UserSettings settings) async {
    await _databaseService.settingsBox.put(_settingsKey, settings);
  }

  // Update specific fields
  Future<void> updateDisplayName(String name) async {
    final settings = getSettings();
    await saveSettings(settings.copyWith(displayName: name));
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final settings = getSettings();
    settings.setThemeMode(mode);
    await saveSettings(settings);
  }

  Future<void> updateNotifications(bool enabled) async {
    final settings = getSettings();
    await saveSettings(settings.copyWith(notificationsEnabled: enabled));
  }

  Future<void> updateReminderTime(String time) async {
    final settings = getSettings();
    await saveSettings(settings.copyWith(reminderTime: time));
  }

  Future<void> updateBiometric(bool enabled) async {
    final settings = getSettings();
    await saveSettings(settings.copyWith(biometricEnabled: enabled));
  }

  Future<void> updateAutoBackup(bool enabled) async {
    final settings = getSettings();
    await saveSettings(settings.copyWith(autoBackup: enabled));
  }

  Future<void> updateLastBackupDate(DateTime date) async {
    final settings = getSettings();
    await saveSettings(settings.copyWith(lastBackupDate: date));
  }

  // Stream for real-time updates
  Stream<UserSettings> watchSettings() {
    return _databaseService.settingsBox
        .watch(key: _settingsKey)
        .map((_) => getSettings());
  }
}
