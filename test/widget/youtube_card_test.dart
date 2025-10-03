import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xrp_monitor/core/services/youtube/models/youtube_model.dart';
import 'package:xrp_monitor/ui/screen/youtube/widget/youtube_card.dart';

void main() {
  group('YoutubeCard Widget Tests', () {
    late YoutubeVideo testVideo;

    setUp(() {
      testVideo = const YoutubeVideo(
        title: 'Test YouTube Video',
        description: 'This is a test video description',
        channelName: 'Test Channel',
        createdAt: '2024-01-01',
        originalLink: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        videoId: 'dQw4w9WgXcQ',
        thumbnails: YoutubeThumbnails(
          high: YoutubeThumbnailItem(
            url: 'https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
            width: 480,
            height: 360,
          ),
        ),
      );
    });

    testWidgets('should display video information correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: YoutubeCard(video: testVideo),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Test YouTube Video'), findsOneWidget);
      expect(find.text('Test Channel'), findsOneWidget);
      expect(find.text('2024-01-01'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });

    testWidgets('should display thumbnail when available', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: YoutubeCard(video: testVideo),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(AspectRatio), findsOneWidget);
    });

    testWidgets('should handle video without thumbnails', (WidgetTester tester) async {
      // Arrange
      final videoWithoutThumbnail = testVideo.copyWith(thumbnails: null);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: YoutubeCard(video: videoWithoutThumbnail),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(Image), findsNothing);
      expect(find.text('Test YouTube Video'), findsOneWidget);
    });

    testWidgets('should handle empty channel name', (WidgetTester tester) async {
      // Arrange
      final videoWithoutChannel = testVideo.copyWith(channelName: '');
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: YoutubeCard(video: videoWithoutChannel),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Test Channel'), findsNothing);
      expect(find.text('Test YouTube Video'), findsOneWidget);
    });

    testWidgets('should be tappable', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: YoutubeCard(video: testVideo),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(InkWell), findsOneWidget);
      // 실제 탭 동작은 YouTube 플레이어 모달을 열려고 하므로
      // 위젯 테스트에서는 InkWell 위젯의 존재만 확인
    });

    testWidgets('should display play icon', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: YoutubeCard(video: testVideo),
            ),
          ),
        ),
      );

      // Act & Assert
      expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
      expect(find.byIcon(Icons.access_time), findsOneWidget);
    });
  });
}