class AppConstants {
  // App Info
  static const String appName = 'Healing Tree';
  static const String appVersion = '0.1.0';

  // Database
  static const String diaryBox = 'diary_box';
  static const String settingsBox = 'settings_box';
  static const String emotionBox = 'emotion_box';

  // API
  static const String openAIModel = 'gpt-4';
  static const int aiMaxTokens = 500;
  static const double aiTemperature = 0.7;

  // UI
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;

  // Animation
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Date Format
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMMM dd, yyyy';

  // Emotion Tags
  static const List<String> emotionTags = [
    'happy',
    'sad',
    'angry',
    'anxious',
    'excited',
    'grateful',
    'lonely',
    'peaceful',
    'confused',
    'hopeful',
  ];

  // Emotion Emojis
  static const Map<String, String> emotionEmojis = {
    'happy': '😊',
    'sad': '😢',
    'angry': '😠',
    'anxious': '😰',
    'excited': '🤗',
    'grateful': '🙏',
    'lonely': '😔',
    'peaceful': '😌',
    'confused': '😕',
    'hopeful': '🌟',
  };

  // Limits
  static const int maxPhotosPerDiary = 5;
  static const int maxDiaryTitleLength = 100;
  static const int maxDiaryContentLength = 10000;
}
