class YoutubeUtils {
  YoutubeUtils._();

  /// YouTube URL에서 video ID를 추출합니다.
  /// 지원하는 URL 형식:
  /// - https://www.youtube.com/watch?v=VIDEO_ID
  /// - https://youtu.be/VIDEO_ID
  /// - https://m.youtube.com/watch?v=VIDEO_ID
  /// - https://youtube.com/watch?v=VIDEO_ID
  static String? extractVideoId(String url) {
    if (url.isEmpty) return null;

    // youtu.be 단축 URL 처리
    final RegExp youtuBeRegExp = RegExp(r'(?:youtu\.be\/)([a-zA-Z0-9_-]{11})');
    final RegExpMatch? youtuBeMatch = youtuBeRegExp.firstMatch(url);
    if (youtuBeMatch != null) {
      return youtuBeMatch.group(1);
    }

    // 일반 YouTube URL 처리 (watch?v=)
    final RegExp youtubeRegExp = RegExp(r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})');
    final RegExpMatch? youtubeMatch = youtubeRegExp.firstMatch(url);
    if (youtubeMatch != null) {
      return youtubeMatch.group(1);
    }

    // URL 파라미터에서 v= 찾기
    final Uri? uri = Uri.tryParse(url);
    if (uri != null) {
      final String? videoId = uri.queryParameters['v'];
      if (videoId != null && videoId.length == 11) {
        return videoId;
      }
    }

    return null;
  }

  /// video ID가 유효한지 확인합니다.
  static bool isValidVideoId(String? videoId) {
    if (videoId == null || videoId.isEmpty) return false;
    
    // YouTube video ID는 11자리이고 영문자, 숫자, _, - 만 포함
    final RegExp regex = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    return regex.hasMatch(videoId);
  }

  /// video ID로 YouTube URL을 생성합니다.
  static String createYoutubeUrl(String videoId) {
    return 'https://www.youtube.com/watch?v=$videoId';
  }

  /// video ID로 YouTube 썸네일 URL을 생성합니다.
  static String createThumbnailUrl(String videoId, {String quality = 'hqdefault'}) {
    // quality 옵션: default, mqdefault, hqdefault, sddefault, maxresdefault
    return 'https://i.ytimg.com/vi/$videoId/$quality.jpg';
  }
}