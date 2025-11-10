import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/user_settings.dart';
import '../../../../core/providers/providers.dart';

// Settings Notifier
class SettingsNotifier extends StateNotifier<UserSettings> {
  final Ref _ref;

  SettingsNotifier(this._ref) : super(_getInitialSettings(_ref)) {
    _loadSettings();
  }

  static UserSettings _getInitialSettings(Ref ref) {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.getSettings();
  }

  void _loadSettings() {
    final repository = _ref.read(settingsRepositoryProvider);
    state = repository.getSettings();
  }

  Future<void> updateDisplayName(String name) async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.updateDisplayName(name);
    _loadSettings();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.updateThemeMode(mode);
    _loadSettings();
  }

  Future<void> updateNotifications(bool enabled) async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.updateNotifications(enabled);
    _loadSettings();
  }

  Future<void> updateReminderTime(String time) async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.updateReminderTime(time);
    _loadSettings();
  }

  Future<void> updateBiometric(bool enabled) async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.updateBiometric(enabled);
    _loadSettings();
  }

  Future<void> updateAutoBackup(bool enabled) async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.updateAutoBackup(enabled);
    _loadSettings();
  }

  Future<void> markBackupCompleted() async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.updateLastBackupDate(DateTime.now());
    _loadSettings();
  }
}

// Settings Provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, UserSettings>((ref) {
  return SettingsNotifier(ref);
});

// Theme Mode Provider
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.theme;
});
