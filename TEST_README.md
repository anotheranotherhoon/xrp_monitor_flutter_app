# XRP Monitor - 테스트 가이드

이 문서는 XRP Monitor Flutter 앱의 테스트 구조와 실행 방법을 설명합니다.

## 📁 테스트 구조

```
test/
├── unit/                    # 유닛 테스트
│   └── utils/
│       ├── youtube_utils_test.dart
│       └── url_utils_test.dart
├── widget/                  # 위젯 테스트
│   ├── youtube_card_test.dart
│   └── news_card_test.dart
└── widget_test.dart         # 기본 앱 테스트

integration_test/
└── app_test.dart           # 통합 테스트
```

## 🧪 테스트 타입

### 1. 유닛 테스트 (Unit Tests)
개별 함수나 클래스의 기능을 테스트합니다.

**포함된 테스트:**
- `YoutubeUtils`: YouTube URL에서 video ID 추출, 유효성 검증 등
- `UrlUtils`: URL 실행 기능 테스트

### 2. 위젯 테스트 (Widget Tests)
Flutter 위젯의 UI와 상호작용을 테스트합니다.

**포함된 테스트:**
- `YoutubeCard`: YouTube 비디오 카드 위젯 테스트
- `NewsCard`: 뉴스 카드 위젯 테스트
- `MyApp`: 기본 앱 구조 테스트

### 3. 통합 테스트 (Integration Tests)
실제 앱의 전체적인 동작을 테스트합니다.

**포함된 테스트:**
- 앱 실행 및 탭 네비게이션
- YouTube 플레이어 모달 동작
- 네트워크 에러 처리

## 🚀 테스트 실행 방법

### 테스트 실행 스크립트 사용

```bash
# 실행 권한 부여 (최초 1회)
chmod +x test_runner.sh

# 유닛 테스트만 실행
./test_runner.sh unit

# 위젯 테스트만 실행
./test_runner.sh widget

# 통합 테스트 실행 (디바이스/에뮬레이터 필요)
./test_runner.sh integration

# 유닛 + 위젯 테스트 실행
./test_runner.sh all

# 테스트 커버리지 생성
./test_runner.sh coverage
```

### 직접 Flutter 명령어 사용

```bash
# 모든 테스트 실행
fvm flutter test

# 특정 폴더의 테스트만 실행
fvm flutter test test/unit/
fvm flutter test test/widget/

# 통합 테스트 실행 (디바이스 필요)
fvm flutter test integration_test/app_test.dart

# 커버리지와 함께 테스트 실행
fvm flutter test --coverage
```

## 📊 테스트 커버리지

테스트 커버리지를 확인하려면:

```bash
# 커버리지 생성
fvm flutter test --coverage

# HTML 리포트 생성 (lcov 설치 필요)
genhtml coverage/lcov.info -o coverage/html

# 브라우저로 리포트 열기
open coverage/html/index.html
```

## 🔧 테스트 환경 설정

### 필요한 의존성

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  integration_test:
    sdk: flutter
```

### 통합 테스트 실행 전 준비사항

1. **Android 에뮬레이터 또는 실제 디바이스 연결**
2. **iOS 시뮬레이터 또는 실제 디바이스 연결**

```bash
# 연결된 디바이스 확인
fvm flutter devices

# 특정 디바이스에서 통합 테스트 실행
fvm flutter test integration_test/app_test.dart -d <device_id>
```

## 📝 테스트 작성 가이드

### 유닛 테스트 예시

```dart
void main() {
  group('YoutubeUtils', () {
    test('should extract video ID from YouTube URL', () {
      // Arrange
      const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
      
      // Act
      final result = YoutubeUtils.extractVideoId(url);
      
      // Assert
      expect(result, 'dQw4w9WgXcQ');
    });
  });
}
```

### 위젯 테스트 예시

```dart
void main() {
  testWidgets('should display video information', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(MaterialApp(
      home: YoutubeCard(video: testVideo),
    ));

    // Act & Assert
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });
}
```

## 🚨 주의사항

1. **네트워크 의존성**: 통합 테스트는 실제 API를 호출할 수 있으므로 네트워크 연결이 필요합니다.

2. **환경 변수**: 테스트 실행 시 프로덕션 환경과 구분되는 테스트 환경 설정을 사용하세요.

3. **Mock 사용**: 외부 의존성은 Mock 객체를 사용하여 테스트의 안정성을 보장하세요.

4. **디바이스 의존성**: 통합 테스트는 실제 디바이스나 에뮬레이터가 필요합니다.



```yaml
# .github/workflows/test.yml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter test --coverage
```

## 📈 모범 사례

1. **AAA 패턴**: Arrange, Act, Assert 패턴을 사용하여 테스트를 구조화하세요.
2. **명확한 테스트 이름**: 테스트가 무엇을 검증하는지 명확하게 표현하세요.
3. **단일 책임**: 각 테스트는 하나의 기능만 테스트하세요.
4. **Mock 활용**: 외부 의존성은 Mock을 사용하여 격리하세요.
5. **정기적인 실행**: 코드 변경 시마다 테스트를 실행하세요.

## 🛠 문제 해결

### 자주 발생하는 문제들

1. **Mock 관련 오류**: `mockito` 패키지 버전 확인
2. **Widget 테스트 실패**: `pumpAndSettle()` 사용으로 비동기 작업 대기
3. **통합 테스트 타임아웃**: 네트워크 요청 시간 초과 설정 조정
4. **의존성 문제**: `flutter clean && flutter pub get` 실행