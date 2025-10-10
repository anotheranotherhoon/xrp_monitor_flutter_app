import 'dart:isolate';
import 'dart:math';
import '../models/news_model.dart';
import '../models/analyzed_news_model.dart';

class NewsAnalysisIsolate {
  static const String _isolateName = 'NewsAnalysisIsolate';

  /// 뉴스 리스트를 분석하는 메인 엔트리 포인트
  static Future<NewsAnalysisResult> analyzeNewsAsync(List<News> newsList) async {
    final receivePort = ReceivePort();
    final stopwatch = Stopwatch()..start();

    try {
      await Isolate.spawn(
        _analyzeNewsInIsolate,
        _IsolateParams(
          sendPort: receivePort.sendPort,
          newsList: newsList,
        ),
        debugName: _isolateName,
      );

      final result = await receivePort.first as NewsAnalysisResult;
      stopwatch.stop();
      
      return NewsAnalysisResult(
        analyzedNews: result.analyzedNews,
        processingTimeMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      receivePort.close();
      throw Exception('뉴스 분석 중 오류 발생: $e');
    } finally {
      receivePort.close();
    }
  }

  /// Isolate에서 실행되는 분석 함수
  static void _analyzeNewsInIsolate(_IsolateParams params) {
    try {
      final analyzedNews = <AnalyzedNews>[];

      for (final news in params.newsList) {
        final analyzedItem = _analyzeNews(news);
        analyzedNews.add(analyzedItem);
      }

      // 정렬은 UI에서 사용자 선택에 따라 처리
      // analyzedNews.sort((a, b) => b.importanceScore.compareTo(a.importanceScore));

      final result = NewsAnalysisResult(
        analyzedNews: analyzedNews,
        processingTimeMs: 0, // 메인에서 계산됨
      );

      params.sendPort.send(result);
    } catch (e) {
      params.sendPort.send(Exception('Isolate 분석 오류: $e'));
    }
  }

  /// 개별 뉴스 아이템 분석
  static AnalyzedNews _analyzeNews(News news) {
    final fullText = '${news.title} ${news.description}';
    
    return AnalyzedNews(
      originalNews: news,
      sentiment: _analyzeSentiment(fullText),
      keywords: _extractKeywords(fullText),
      importanceScore: _calculateImportanceScore(news, fullText),
      entities: _extractEntities(fullText),
      readingTimeMinutes: _estimateReadingTime(fullText),
    );
  }

  /// 감성분석 - 단순한 키워드 기반 접근법
  static SentimentAnalysis _analyzeSentiment(String text) {
    final lowerText = text.toLowerCase();
    
    // XRP/암호화폐 관련 긍정/부정 키워드
    final positiveKeywords = [
      '상승', '증가', '성장', '호재', '긍정', '좋은', '최고', '신고가', '급등', '폭등',
      'pump', 'moon', 'bullish', 'positive', 'growth', 'increase', 'rise', 'surge',
      '돌파', '랠리', '상승세', '강세', '매수', '투자', '수익'
    ];
    
    final negativeKeywords = [
      '하락', '감소', '악재', '부정', '나쁜', '최저', '급락', '폭락', '손실',
      'dump', 'crash', 'bearish', 'negative', 'decline', 'drop', 'fall', 'loss',
      '붕괴', '하향', '하락세', '약세', '매도', '위험', '규제'
    ];

    double positiveScore = 0;
    double negativeScore = 0;

    for (final keyword in positiveKeywords) {
      final matches = RegExp(keyword, caseSensitive: false).allMatches(text).length;
      positiveScore += matches;
    }

    for (final keyword in negativeKeywords) {
      final matches = RegExp(keyword, caseSensitive: false).allMatches(text).length;
      negativeScore += matches;
    }

    final totalScore = positiveScore + negativeScore;
    if (totalScore == 0) {
      return const SentimentAnalysis(
        type: SentimentType.neutral,
        score: 0.0,
        confidence: 0.5,
      );
    }

    final sentimentScore = (positiveScore - negativeScore) / totalScore;
    final confidence = min(totalScore / 10, 1.0); // 최대 1.0

    SentimentType type;
    if (sentimentScore > 0.2) {
      type = SentimentType.positive;
    } else if (sentimentScore < -0.2) {
      type = SentimentType.negative;
    } else {
      type = SentimentType.neutral;
    }

    return SentimentAnalysis(
      type: type,
      score: sentimentScore.clamp(-1.0, 1.0),
      confidence: confidence,
    );
  }

  /// 키워드 추출
  static List<String> _extractKeywords(String text) {
    final lowerText = text.toLowerCase();
    
    // XRP/암호화폐 관련 중요 키워드들
    final importantKeywords = [
      'xrp', 'ripple', 'bitcoin', 'ethereum', 'cryptocurrency', 'crypto',
      '리플', '비트코인', '이더리움', '암호화폐', '코인', '블록체인',
      'sec', 'lawsuit', 'regulation', '소송', '규제', 'partnership',
      '파트너십', 'adoption', '채택', 'price', '가격', 'market', '시장',
      'trading', '거래', 'volume', '거래량', 'breakout', '돌파'
    ];

    final foundKeywords = <String>[];
    
    for (final keyword in importantKeywords) {
      if (lowerText.contains(keyword)) {
        foundKeywords.add(keyword);
      }
    }

    // 빈도순으로 정렬하고 최대 5개까지만
    return foundKeywords.take(5).toList();
  }

  /// 엔티티 추출 (간단한 규칙 기반)
  static List<String> _extractEntities(String text) {
    final entities = <String>[];
    
    // 대문자로 시작하는 연속된 단어들 (회사명, 인명 등)
    final entityRegex = RegExp(r'\b[A-Z][a-z]+(?:\s+[A-Z][a-z]+)*\b');
    final matches = entityRegex.allMatches(text);
    
    for (final match in matches) {
      final entity = match.group(0);
      if (entity != null && entity.length > 2) {
        entities.add(entity);
      }
    }
    
    return entities.take(3).toList();
  }

  /// 읽기 시간 추정 (분)
  static int _estimateReadingTime(String text) {
    const wordsPerMinute = 200; // 평균 읽기 속도
    final wordCount = text.split(RegExp(r'\s+')).length;
    return max(1, (wordCount / wordsPerMinute).ceil());
  }

  /// 중요도 점수 계산
  static double _calculateImportanceScore(News news, String fullText) {
    double score = 0.0;

    // 제목에 XRP 관련 키워드가 있으면 높은 점수
    final titleLower = news.title.toLowerCase();
    if (titleLower.contains('xrp') || titleLower.contains('ripple')) {
      score += 0.3;
    }

    // 감성분석 점수 반영
    final sentiment = _analyzeSentiment(fullText);
    score += sentiment.confidence * 0.2;

    // 키워드 개수에 따른 점수
    final keywordCount = _extractKeywords(fullText).length;
    score += (keywordCount / 10) * 0.2;

    // 텍스트 길이에 따른 점수 (너무 짧지도 길지도 않게)
    final textLength = fullText.length;
    if (textLength > 100 && textLength < 1000) {
      score += 0.2;
    }

    // 최신성 점수 (createdAt이 최근일수록 높은 점수)
    try {
      final createdAt = DateTime.parse(news.createdAt);
      final daysDiff = DateTime.now().difference(createdAt).inDays;
      if (daysDiff == 0) {
        score += 0.1; // 오늘 뉴스
      } else if (daysDiff <= 3){
        score += 0.05;// 3일 이내
      }
    } catch (e) {
      // 날짜 파싱 실패시 무시
    }

    return score.clamp(0.0, 1.0);
  }
}

class _IsolateParams {
  const _IsolateParams({
    required this.sendPort,
    required this.newsList,
  });

  final SendPort sendPort;
  final List<News> newsList;
}