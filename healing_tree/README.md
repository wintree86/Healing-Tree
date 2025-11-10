# Healing Tree App

Flutter application for Healing Tree - AI-based emotional care diary app.

## Project Structure

```
healing_tree/
├── lib/
│   ├── core/
│   │   ├── constants/      # App-wide constants
│   │   ├── theme/          # Theme configuration
│   │   ├── utils/          # Utility functions
│   │   ├── routes/         # Route configuration
│   │   └── errors/         # Error handling
│   ├── features/
│   │   ├── auth/           # Authentication feature
│   │   ├── diary/          # Diary CRUD feature
│   │   ├── statistics/     # Statistics & analytics
│   │   └── settings/       # App settings
│   └── shared/
│       ├── models/         # Shared data models
│       ├── widgets/        # Reusable widgets
│       └── services/       # API & services
├── assets/
│   ├── images/            # Image assets
│   └── fonts/             # Font files
└── test/                  # Test files

```

## Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Create `.env` file from `.env.example`:
```bash
cp .env.example .env
```

4. Add your API keys to `.env` file

5. Run the app:
```bash
flutter run
```

## Dependencies

### State Management
- **flutter_riverpod**: Modern state management solution
- **riverpod_annotation**: Code generation for Riverpod

### Database
- **hive**: Fast, lightweight local database
- **hive_flutter**: Flutter-specific Hive utilities

### UI/UX
- **go_router**: Declarative routing
- **fl_chart**: Beautiful charts and graphs
- **cached_network_image**: Efficient image loading

### Backend
- **firebase_core**: Firebase initialization
- **firebase_auth**: Authentication
- **cloud_firestore**: Cloud database
- **firebase_storage**: File storage

### AI Integration
- Will be integrated via REST API (dio/http)

## Development

### Code Generation

Run code generation when you add new models or providers:

```bash
flutter pub run build_runner watch
```

### Testing

Run tests:

```bash
flutter test
```

### Building

Build for Android:
```bash
flutter build apk
```

Build for iOS:
```bash
flutter build ios
```

## Features (Planned)

- [ ] User authentication
- [ ] Diary writing with rich text
- [ ] AI-based emotion analysis
- [ ] Emotion tracking calendar
- [ ] Statistics dashboard
- [ ] Photo attachments
- [ ] Voice diary (STT)
- [ ] Cloud backup
- [ ] Dark mode
- [ ] Biometric lock

## License

This project is part of the Healing Tree initiative.
