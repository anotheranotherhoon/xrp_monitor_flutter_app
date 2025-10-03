import 'package:flutter_test/flutter_test.dart';
import 'package:xrp_monitor/ui/utils/youtube_utils.dart';

void main() {
  group('YoutubeUtils', () {
    group('extractVideoId', () {
      test('should extract video ID from standard YouTube URL', () {
        // Arrange
        const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
        
        // Act
        final result = YoutubeUtils.extractVideoId(url);
        
        // Assert
        expect(result, 'dQw4w9WgXcQ');
      });

      test('should extract video ID from youtu.be short URL', () {
        // Arrange
        const url = 'https://youtu.be/dQw4w9WgXcQ';
        
        // Act
        final result = YoutubeUtils.extractVideoId(url);
        
        // Assert
        expect(result, 'dQw4w9WgXcQ');
      });

      test('should extract video ID from mobile YouTube URL', () {
        // Arrange
        const url = 'https://m.youtube.com/watch?v=dQw4w9WgXcQ';
        
        // Act
        final result = YoutubeUtils.extractVideoId(url);
        
        // Assert
        expect(result, 'dQw4w9WgXcQ');
      });

      test('should extract video ID from URL with additional parameters', () {
        // Arrange
        const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ&t=30s&list=PLx';
        
        // Act
        final result = YoutubeUtils.extractVideoId(url);
        
        // Assert
        expect(result, 'dQw4w9WgXcQ');
      });

      test('should return null for empty URL', () {
        // Arrange
        const url = '';
        
        // Act
        final result = YoutubeUtils.extractVideoId(url);
        
        // Assert
        expect(result, isNull);
      });

      test('should return null for invalid URL', () {
        // Arrange
        const url = 'https://example.com/not-youtube';
        
        // Act
        final result = YoutubeUtils.extractVideoId(url);
        
        // Assert
        expect(result, isNull);
      });

      test('should return null for YouTube URL without video ID', () {
        // Arrange
        const url = 'https://www.youtube.com/';
        
        // Act
        final result = YoutubeUtils.extractVideoId(url);
        
        // Assert
        expect(result, isNull);
      });

      test('should handle embed URLs', () {
        // Arrange
        const url = 'https://www.youtube.com/embed/dQw4w9WgXcQ';
        
        // Act
        final result = YoutubeUtils.extractVideoId(url);
        
        // Assert
        expect(result, 'dQw4w9WgXcQ');
      });
    });

    group('isValidVideoId', () {
      test('should return true for valid 11-character video ID', () {
        // Arrange
        const videoId = 'dQw4w9WgXcQ';
        
        // Act
        final result = YoutubeUtils.isValidVideoId(videoId);
        
        // Assert
        expect(result, isTrue);
      });

      test('should return true for video ID with allowed characters', () {
        // Arrange
        const videoId = 'ABC123xyz_-';
        
        // Act
        final result = YoutubeUtils.isValidVideoId(videoId);
        
        // Assert
        expect(result, isTrue);
      });

      test('should return false for null video ID', () {
        // Arrange
        const String? videoId = null;
        
        // Act
        final result = YoutubeUtils.isValidVideoId(videoId);
        
        // Assert
        expect(result, isFalse);
      });

      test('should return false for empty video ID', () {
        // Arrange
        const videoId = '';
        
        // Act
        final result = YoutubeUtils.isValidVideoId(videoId);
        
        // Assert
        expect(result, isFalse);
      });

      test('should return false for too short video ID', () {
        // Arrange
        const videoId = 'short';
        
        // Act
        final result = YoutubeUtils.isValidVideoId(videoId);
        
        // Assert
        expect(result, isFalse);
      });

      test('should return false for too long video ID', () {
        // Arrange
        const videoId = 'thisistoolong';
        
        // Act
        final result = YoutubeUtils.isValidVideoId(videoId);
        
        // Assert
        expect(result, isFalse);
      });

      test('should return false for video ID with invalid characters', () {
        // Arrange
        const videoId = 'invalid@id!';
        
        // Act
        final result = YoutubeUtils.isValidVideoId(videoId);
        
        // Assert
        expect(result, isFalse);
      });
    });

    group('createYoutubeUrl', () {
      test('should create correct YouTube URL from video ID', () {
        // Arrange
        const videoId = 'dQw4w9WgXcQ';
        
        // Act
        final result = YoutubeUtils.createYoutubeUrl(videoId);
        
        // Assert
        expect(result, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
      });
    });

    group('createThumbnailUrl', () {
      test('should create correct thumbnail URL with default quality', () {
        // Arrange
        const videoId = 'dQw4w9WgXcQ';
        
        // Act
        final result = YoutubeUtils.createThumbnailUrl(videoId);
        
        // Assert
        expect(result, 'https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg');
      });

      test('should create correct thumbnail URL with custom quality', () {
        // Arrange
        const videoId = 'dQw4w9WgXcQ';
        const quality = 'maxresdefault';
        
        // Act
        final result = YoutubeUtils.createThumbnailUrl(videoId, quality: quality);
        
        // Assert
        expect(result, 'https://i.ytimg.com/vi/dQw4w9WgXcQ/maxresdefault.jpg');
      });
    });
  });
}