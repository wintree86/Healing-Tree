# Healing Tree - Architecture Documentation

## Project Structure

```
healing_tree/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── core/                        # Core functionality
│   │   ├── constants/
│   │   │   └── app_constants.dart   # App-wide constants
│   │   ├── theme/
│   │   │   └── app_theme.dart       # Light & Dark themes
│   │   ├── routes/
│   │   │   └── app_router.dart      # GoRouter configuration
│   │   ├── utils/                   # Utility functions
│   │   └── errors/                  # Error handling
│   ├── features/                    # Feature modules
│   │   ├── auth/                    # Authentication
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── diary/                   # Diary management
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           ├── home_screen.dart
│   │   │           ├── diary_write_screen.dart
│   │   │           └── diary_detail_screen.dart
│   │   ├── statistics/              # Analytics & charts
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── statistics_screen.dart
│   │   └── settings/                # App settings
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │           └── screens/
│   │               └── settings_screen.dart
│   └── shared/                      # Shared resources
│       ├── models/                  # Data models
│       ├── widgets/                 # Reusable widgets
│       └── services/                # API & services
├── assets/
│   ├── images/                      # Image assets
│   └── fonts/                       # Font files
├── test/                            # Tests
├── pubspec.yaml                     # Dependencies
└── analysis_options.yaml            # Linter rules
```

## Architecture Pattern

This project follows **Clean Architecture** principles with a feature-first organization:

### Layers

1. **Presentation Layer** (`presentation/`)
   - Screens/Pages
   - Widgets
   - State Management (Riverpod)

2. **Domain Layer** (`domain/`)
   - Entities
   - Use Cases
   - Repository Interfaces

3. **Data Layer** (`data/`)
   - Repository Implementations
   - Data Sources (Local/Remote)
   - Models & DTOs

### Data Flow

```
UI (Widget)
  ↓
State Management (Riverpod Provider)
  ↓
Use Case
  ↓
Repository Interface
  ↓
Repository Implementation
  ↓
Data Source (Hive/Firebase)
```

## State Management

**Riverpod** is used for state management with the following providers:

- `Provider`: For immutable data
- `StateProvider`: For simple state
- `StateNotifierProvider`: For complex state logic
- `FutureProvider`: For async data
- `StreamProvider`: For real-time data

### Code Generation

Riverpod uses code generation for type-safe providers:

```dart
@riverpod
class DiaryNotifier extends _$DiaryNotifier {
  // Implementation
}
```

## Database Schema

### Local Database (Hive)

**DiaryEntry Box**
```dart
@HiveType(typeId: 0)
class DiaryEntry {
  @HiveField(0) String id;
  @HiveField(1) DateTime createdAt;
  @HiveField(2) String? title;
  @HiveField(3) String content;
  @HiveField(4) List<String> emotions;
  @HiveField(5) List<String> photoUrls;
  @HiveField(6) bool isFavorite;
}
```

**Settings Box**
```dart
@HiveType(typeId: 1)
class UserSettings {
  @HiveField(0) ThemeMode themeMode;
  @HiveField(1) bool notificationsEnabled;
  @HiveField(2) String? reminderTime;
}
```

### Cloud Database (Firestore)

```
users/
  └── {userId}/
      ├── profile/
      ├── diaries/
      │   └── {diaryId}/
      │       ├── content
      │       ├── emotions
      │       ├── createdAt
      │       └── aiFeedback/
      └── statistics/
```

## Navigation

**GoRouter** handles all navigation with named routes:

```dart
context.push('/diary/write');           // Navigate
context.go('/');                        // Go to route
context.pop();                          // Go back
```

### Routes

- `/` - Home Screen
- `/diary/write` - Write Diary
- `/diary/:id` - Diary Detail
- `/statistics` - Statistics
- `/settings` - Settings

## Theming

Material Design 3 with custom color scheme:

- **Primary**: Green (#4CAF50) - Growth & Healing
- **Secondary**: Blue (#64B5F6) - Calmness
- **Tertiary**: Orange (#FFA726) - Energy

Both Light and Dark themes are supported.

## AI Integration

### OpenAI API Flow

1. User writes diary entry
2. Content sent to OpenAI API
3. AI analyzes emotions and provides feedback
4. Response stored with diary entry

### API Service Structure

```dart
class AIService {
  Future<AIFeedback> analyzeDiary(String content);
  Future<List<String>> generateQuestions(String content);
  Future<String> generateEncouragement(String emotion);
}
```

## Error Handling

Centralized error handling with custom exceptions:

```dart
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class DatabaseException extends AppException {
  const DatabaseException(super.message);
}
```

## Testing Strategy

### Unit Tests
- Business logic
- Use cases
- Utilities

### Widget Tests
- Individual widgets
- Screens

### Integration Tests
- Complete user flows
- API integration

## Security

1. **Local Storage**: Encrypted with `flutter_secure_storage`
2. **Biometric Auth**: Using `local_auth` package
3. **API Keys**: Stored in `.env` file (not in VCS)
4. **Firebase**: Security rules configured

## Performance Optimization

1. **Lazy Loading**: Images and data loaded on demand
2. **Caching**: Network images cached
3. **Code Splitting**: Feature-based modules
4. **State Optimization**: Minimal rebuilds with Riverpod

## Build Variants

### Development
```bash
flutter run --debug
```

### Production
```bash
flutter build apk --release
flutter build ios --release
```

## Dependencies Management

All dependencies are version-pinned in `pubspec.yaml`:

### Core Dependencies
- `flutter_riverpod`: State management
- `go_router`: Navigation
- `hive`: Local database
- `firebase_core`: Backend

### Development Dependencies
- `build_runner`: Code generation
- `flutter_lints`: Code quality

## Code Generation

Generate code for Riverpod, Hive, JSON serialization:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Watch mode for development:

```bash
flutter pub run build_runner watch
```

## Future Enhancements

1. **Offline-first**: Complete offline functionality
2. **Widget**: Home screen widget
3. **Watch App**: Smartwatch companion
4. **Web Version**: Progressive Web App
5. **Analytics**: User behavior tracking (privacy-focused)

---

This architecture is designed to be:
- **Scalable**: Easy to add new features
- **Maintainable**: Clear separation of concerns
- **Testable**: Each layer can be tested independently
- **Flexible**: Easy to swap implementations
