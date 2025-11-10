# Healing Tree - Development Guide

## 프로젝트 개요

이 저장소는 Healing Tree Flutter 앱의 전체 프로젝트 구조를 포함합니다.

## 디렉토리 구조

```
Healing-Tree/
├── PROJECT_PROPOSAL.md          # 프로젝트 기획서
├── README.md                     # 프로젝트 소개
├── DEVELOPMENT_GUIDE.md          # 개발 가이드 (이 문서)
└── healing_tree/                 # Flutter 앱
    ├── lib/                      # 소스 코드
    ├── assets/                   # 리소스 파일
    ├── test/                     # 테스트
    ├── pubspec.yaml              # 의존성
    ├── ARCHITECTURE.md           # 아키텍처 문서
    └── README.md                 # 앱 설명서
```

## 개발 환경 설정

### 1. Flutter 설치

Flutter SDK가 필요합니다. 아래 명령어로 설치 여부를 확인하세요:

```bash
flutter --version
```

설치되어 있지 않다면 [Flutter 공식 문서](https://flutter.dev/docs/get-started/install)를 참고하세요.

### 2. 프로젝트 클론

```bash
git clone https://github.com/yourusername/Healing-Tree.git
cd Healing-Tree/healing_tree
```

### 3. 의존성 설치

```bash
flutter pub get
```

### 4. 환경 변수 설정

`.env.example` 파일을 복사하여 `.env` 파일을 생성하고 API 키를 입력하세요:

```bash
cp .env.example .env
```

`.env` 파일 내용:
```env
OPENAI_API_KEY=your_actual_api_key_here
```

### 5. 코드 생성

Riverpod, Hive 등의 코드를 생성합니다:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 개발 워크플로우

### 1. 새로운 기능 개발

1. 기능별 브랜치 생성:
```bash
git checkout -b feature/diary-list
```

2. 개발 진행
3. 커밋 및 푸시

### 2. 코드 생성 (Watch 모드)

개발 중 자동으로 코드 생성:

```bash
flutter pub run build_runner watch
```

### 3. 앱 실행

```bash
# 개발 모드
flutter run

# 특정 디바이스
flutter run -d chrome        # 웹
flutter run -d android       # 안드로이드
flutter run -d ios           # iOS
```

### 4. 테스트

```bash
# 모든 테스트 실행
flutter test

# 특정 테스트
flutter test test/features/diary_test.dart

# 커버리지
flutter test --coverage
```

## 주요 개발 작업

### Phase 1: MVP (현재)

- [x] 프로젝트 구조 설정
- [x] 기본 화면 UI
- [ ] Hive 데이터베이스 구현
- [ ] 일기 CRUD 기능
- [ ] AI 피드백 통합

### Phase 2: 핵심 기능

- [ ] 감정 달력
- [ ] 통계 차트
- [ ] 사진 첨부
- [ ] 검색 기능

### Phase 3: 고급 기능

- [ ] Firebase 연동
- [ ] 음성 일기 (STT)
- [ ] 알림 시스템
- [ ] 생체 인증

## 코드 스타일 가이드

### Dart 코드 규칙

1. **파일명**: `snake_case.dart`
2. **클래스명**: `PascalCase`
3. **변수/함수명**: `camelCase`
4. **상수**: `lowerCamelCase` (Dart 컨벤션)
5. **Private 멤버**: `_leadingUnderscore`

### 코드 포맷팅

```bash
# 자동 포맷팅
flutter format lib/

# 린트 체크
flutter analyze
```

### Widget 작성 규칙

```dart
class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Trailing comma for better formatting
      child: Text(title),
    );
  }
}
```

### Riverpod Provider 작성

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

@riverpod
class DiaryNotifier extends _$DiaryNotifier {
  @override
  List<Diary> build() {
    return [];
  }

  void addDiary(Diary diary) {
    state = [...state, diary];
  }
}
```

## 문제 해결

### 빌드 에러

```bash
# 클린 빌드
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### iOS 빌드 이슈

```bash
cd ios
pod install
cd ..
flutter run
```

### 안드로이드 빌드 이슈

```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter run
```

## 배포

### 안드로이드

1. 키 생성 (최초 1회):
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. 빌드:
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS

1. Xcode에서 signing 설정
2. 빌드:
```bash
flutter build ios --release
```

## 유용한 명령어

```bash
# Flutter 버전 확인
flutter --version

# 연결된 디바이스 확인
flutter devices

# 의존성 업데이트
flutter pub upgrade

# 앱 성능 프로파일링
flutter run --profile

# 릴리즈 빌드 로컬 테스트
flutter run --release

# 빌드 크기 분석
flutter build apk --analyze-size
```

## 디버깅 팁

### Flutter DevTools

```bash
flutter pub global activate devtools
flutter pub global run devtools
```

### 로그 확인

```dart
import 'package:flutter/foundation.dart';

if (kDebugMode) {
  print('Debug message');
}
```

### Riverpod DevTools

Riverpod의 상태를 확인하려면 Flutter DevTools의 Provider 탭을 사용하세요.

## 기여 가이드

1. 이슈 생성 또는 확인
2. 브랜치 생성: `feature/기능명` 또는 `fix/버그명`
3. 코드 작성 및 테스트
4. 커밋 메시지: 명확하고 간결하게
5. Pull Request 생성

### 커밋 메시지 컨벤션

```
feat: 새로운 기능 추가
fix: 버그 수정
docs: 문서 수정
style: 코드 포맷팅, 세미콜론 누락 등
refactor: 코드 리팩토링
test: 테스트 코드 추가
chore: 빌드 작업, 패키지 매니저 설정 등
```

## 참고 자료

### 공식 문서
- [Flutter 공식 문서](https://flutter.dev/docs)
- [Dart 공식 문서](https://dart.dev/guides)
- [Riverpod 문서](https://riverpod.dev/)
- [GoRouter 문서](https://pub.dev/packages/go_router)
- [Hive 문서](https://docs.hivedb.dev/)

### 프로젝트 문서
- [프로젝트 기획서](PROJECT_PROPOSAL.md)
- [아키텍처 문서](healing_tree/ARCHITECTURE.md)
- [앱 README](healing_tree/README.md)

## 지원

문제가 발생하면 GitHub Issues에 등록해주세요.

---

Happy Coding! 🌳
