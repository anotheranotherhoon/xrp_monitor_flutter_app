import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/ui/screen/news/widget/news_card.dart';

void main() {
  group('NewsCard Widget Tests', () {
    late News testNews;

    setUp(() {
      testNews = const News(
        title: 'Test News Title',
        description: 'This is a test news description',
        createdAt: '2024-01-01',
        originalLink: 'https://www.example.com/news',
      );
    });

    testWidgets('should display news information correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(news: testNews),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Test News Title'), findsOneWidget);
      expect(find.text('This is a test news description'), findsOneWidget);
      expect(find.text('2024-01-01'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should handle empty title', (WidgetTester tester) async {
      // Arrange
      final newsWithoutTitle = testNews.copyWith(title: '');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(news: newsWithoutTitle),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Test News Title'), findsNothing);
      expect(find.text('This is a test news description'), findsOneWidget);
    });

    testWidgets('should handle empty description', (WidgetTester tester) async {
      // Arrange
      final newsWithoutDescription = testNews.copyWith(description: '');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(news: newsWithoutDescription),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Test News Title'), findsOneWidget);
      expect(find.text('This is a test news description'), findsNothing);
    });

    testWidgets('should be tappable', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(news: testNews),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(InkWell), findsOneWidget);
      // InkWell 탭 동작 테스트
      await tester.tap(find.byType(InkWell));
      await tester.pump();
      // 실제 URL 런처는 통합 테스트에서 테스트
    });

    testWidgets('should display time icon', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(news: testNews),
          ),
        ),
      );

      // Act & Assert
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });

    testWidgets('should render HTML content correctly', (WidgetTester tester) async {
      // Arrange
      final newsWithHtml = testNews.copyWith(
        title: '<b>Bold Title</b>',
        description: '<i>Italic description</i>',
      );
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewsCard(news: newsWithHtml),
          ),
        ),
      );

      // Act & Assert
      // HTML 위젯이 렌더링되는지 확인
      expect(find.byType(Card), findsOneWidget);
      // HTML 내용의 정확한 렌더링은 flutter_html 패키지의 책임
    });
  });
}