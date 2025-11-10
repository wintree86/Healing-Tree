import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_settings.g.dart';

@HiveType(typeId: 2)
class UserSettings extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  String? displayName;

  @HiveField(2)
  String? profileImageUrl;

  @HiveField(3)
  int themeMode; // 0: system, 1: light, 2: dark

  @HiveField(4)
  bool notificationsEnabled;

  @HiveField(5)
  String? reminderTime; // Format: "HH:mm"

  @HiveField(6)
  bool biometricEnabled;

  @HiveField(7)
  bool autoBackup;

  @HiveField(8)
  DateTime? lastBackupDate;

  UserSettings({
    required this.userId,
    this.displayName,
    this.profileImageUrl,
    this.themeMode = 0,
    this.notificationsEnabled = true,
    this.reminderTime,
    this.biometricEnabled = false,
    this.autoBackup = false,
    this.lastBackupDate,
  });

  // Convert int to ThemeMode
  ThemeMode get theme {
    switch (themeMode) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  // Set ThemeMode
  void setThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        themeMode = 1;
        break;
      case ThemeMode.dark:
        themeMode = 2;
        break;
      default:
        themeMode = 0;
    }
  }

  // Copy with method
  UserSettings copyWith({
    String? userId,
    String? displayName,
    String? profileImageUrl,
    int? themeMode,
    bool? notificationsEnabled,
    String? reminderTime,
    bool? biometricEnabled,
    bool? autoBackup,
    DateTime? lastBackupDate,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoBackup: autoBackup ?? this.autoBackup,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }
}
