import 'dart:isolate';
import 'dart:math';
import '../models/news_model.dart';
import '../models/analyzed_news_model.dart';
import '../../keyword/models/keyword_model.dart';

class NewsAnalysisIsolate {
  static const String _isolateName = 'NewsAnalysisIsolate';

  /// 뉴스 리스트를 분석하는 메인 엔트리 포인트
  static Future<NewsAnalysisResult> analyzeNewsAsync(
    List<News> newsList, {
    KeywordListResponse? keywords,
  }) async {
    final ReceivePort receivePort = ReceivePort();
    final Stopwatch stopwatch = Stopwatch()..start();

    try {
      await Isolate.spawn(
        _analyzeNewsInIsolate,
        _IsolateParams(
          sendPort: receivePort.sendPort,
          newsList: newsList,
          keywords: keywords,
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
      final List<AnalyzedNews> analyzedNews = <AnalyzedNews>[];

      for (final news in params.newsList) {
        final AnalyzedNews analyzedItem = _analyzeNews(news, params.keywords);
        analyzedNews.add(analyzedItem);
      }

      // 정렬은 UI에서 사용자 선택에 따라 처리
      // analyzedNews.sort((a, b) => b.importanceScore.compareTo(a.importanceScore));

      final NewsAnalysisResult result = NewsAnalysisResult(
        analyzedNews: analyzedNews,
        processingTimeMs: 0, // 메인에서 계산됨
      );

      params.sendPort.send(result);
    } catch (e) {
      params.sendPort.send(Exception('Isolate 분석 오류: $e'));
    }
  }

  /// 개별 뉴스 아이템 분석
  static AnalyzedNews _analyzeNews(News news, KeywordListResponse? keywords) {
    final String fullText = '${news.title} ${news.description}';
    
    return AnalyzedNews(
      originalNews: news,
      sentiment: _analyzeSentiment(fullText, keywords),
      keywords: _extractKeywords(fullText, keywords),
      importanceScore: _calculateImportanceScore(news, fullText, keywords),
      entities: _extractEntities(fullText),
      readingTimeMinutes: _estimateReadingTime(fullText),
    );
  }

  /// 감성분석 - KeywordService 데이터를 활용한 가중치 기반 분석
  static SentimentAnalysis _analyzeSentiment(String text, KeywordListResponse? keywords) {
    double positiveScore = 0.0;
    double negativeScore = 0.0;

    if (keywords != null) {
      // API에서 가져온 긍정 키워드 분석 (가중치 적용)
      for (final keyword in keywords.positiveKeywords) {
        if (keyword.isActive) {
          final int matches = RegExp(keyword.keyword, caseSensitive: false).allMatches(text).length;
          final double weight = double.tryParse(keyword.weight) ?? 1.0;
          positiveScore += matches * weight;
        }
      }

      // API에서 가져온 부정 키워드 분석 (가중치 적용)
      for (final keyword in keywords.negativeKeywords) {
        if (keyword.isActive) {
          final int matches = RegExp(keyword.keyword, caseSensitive: false).allMatches(text).length;
          final double weight = double.tryParse(keyword.weight) ?? 1.0;
          negativeScore += matches * weight;
        }
      }
    }

    // 기본 키워드 (fallback)
    final List<String> defaultPositiveKeywords = [
      '상승', '증가', '성장', '호재', '긍정', '좋은', '최고', '신고가', '급등', '폭등',
      'pump', 'moon', 'bullish', 'positive', 'growth', 'increase', 'rise', 'surge',
      '돌파', '랠리', '상승세', '강세', '매수', '투자', '수익'
    ];
    
    final List<String> defaultNegativeKeywords = [
      '하락', '감소', '악재', '부정', '나쁜', '최저', '급락', '폭락', '손실',
      'dump', 'crash', 'bearish', 'negative', 'decline', 'drop', 'fall', 'loss',
      '붕괴', '하향', '하락세', '약세', '매도', '위험', '규제'
    ];

    // 기본 키워드로 보완 (가중치 0.5)
    for (final keyword in defaultPositiveKeywords) {
      final int matches = RegExp(keyword, caseSensitive: false).allMatches(text).length;
      positiveScore += matches * 0.5;
    }

    for (final keyword in defaultNegativeKeywords) {
      final int matches = RegExp(keyword, caseSensitive: false).allMatches(text).length;
      negativeScore += matches * 0.5;
    }

    final double totalScore = positiveScore + negativeScore;
    if (totalScore == 0) {
      return const SentimentAnalysis(
        type: SentimentType.neutral,
        score: 0.0,
        confidence: 0.5,
      );
    }

    final double sentimentScore = (positiveScore - negativeScore) / totalScore;
    final double confidence = min(totalScore / 10, 1.0); // 최대 1.0

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

  /// 키워드 추출 - KeywordService 데이터 활용
  static List<String> _extractKeywords(String text, KeywordListResponse? keywords) {
    final String lowerText = text.toLowerCase();
    final List<String> foundKeywords = <String>[];
    
    if (keywords != null) {
      // API에서 가져온 중요 키워드들 우선 검사
      for (final keyword in keywords.importantKeywords) {
        if (keyword.isActive && lowerText.contains(keyword.keyword.toLowerCase())) {
          foundKeywords.add(keyword.keyword);
        }
      }

      // 긍정/부정 키워드도 포함
      for (final keyword in [...keywords.positiveKeywords, ...keywords.negativeKeywords]) {
        if (keyword.isActive && 
            lowerText.contains(keyword.keyword.toLowerCase()) && 
            !foundKeywords.contains(keyword.keyword)) {
          foundKeywords.add(keyword.keyword);
        }
      }
    }

    // 기본 키워드로 보완
    final List<String> defaultKeywords = [
      'xrp', 'ripple', 'bitcoin', 'ethereum', 'cryptocurrency', 'crypto',
      '리플', '비트코인', '이더리움', '암호화폐', '코인', '블록체인',
      'sec', 'lawsuit', 'regulation', '소송', '규제', 'partnership',
      '파트너십', 'adoption', '채택', 'price', '가격', 'market', '시장',
      'trading', '거래', 'volume', '거래량', 'breakout', '돌파'
    ];
    
    for (final keyword in defaultKeywords) {
      if (lowerText.contains(keyword) && !foundKeywords.contains(keyword)) {
        foundKeywords.add(keyword);
      }
    }

    return foundKeywords.take(5).toList();
  }

  /// 엔티티 추출 (간단한 규칙 기반)
  static List<String> _extractEntities(String text) {
    final List<String> entities = <String>[];
    
    // 대문자로 시작하는 연속된 단어들 (회사명, 인명 등)
    final RegExp entityRegex = RegExp(r'\b[A-Z][a-z]+(?:\s+[A-Z][a-z]+)*\b');
    final Iterable<RegExpMatch> matches = entityRegex.allMatches(text);
    
    for (final match in matches) {
      final String? entity = match.group(0);
      if (entity != null && entity.length > 2) {
        entities.add(entity);
      }
    }
    
    return entities.take(3).toList();
  }

  /// 읽기 시간 추정 (분)
  static int _estimateReadingTime(String text) {
    const int wordsPerMinute = 200; // 평균 읽기 속도
    final int wordCount = text.split(RegExp(r'\s+')).length;
    return max(1, (wordCount / wordsPerMinute).ceil());
  }

  /// 중요도 점수 계산 - KeywordService 데이터 활용
  static double _calculateImportanceScore(News news, String fullText, KeywordListResponse? keywords) {
    double score = 0.0;

    // KeywordService 키워드 기반 점수 계산
    if (keywords != null) {
      final String textLower = fullText.toLowerCase();
      
      // 중요 키워드 가중치 적용
      for (final keyword in keywords.importantKeywords) {
        if (keyword.isActive && textLower.contains(keyword.keyword.toLowerCase())) {
          final double weight = double.tryParse(keyword.weight) ?? 1.0;
          score += weight * 0.3; // 중요 키워드는 높은 가중치
        }
      }

      // 긍정/부정 키워드 가중치 적용
      for (final keyword in [...keywords.positiveKeywords, ...keywords.negativeKeywords]) {
        if (keyword.isActive && textLower.contains(keyword.keyword.toLowerCase())) {
          final double weight = double.tryParse(keyword.weight) ?? 1.0;
          score += weight * 0.2;
        }
      }
    }

    // 제목에 XRP 관련 키워드가 있으면 추가 점수
    final String titleLower = news.title.toLowerCase();
    if (titleLower.contains('xrp') || titleLower.contains('ripple')) {
      score += 0.2;
    }

    // 감성분석 점수 반영
    final SentimentAnalysis sentiment = _analyzeSentiment(fullText, keywords);
    score += sentiment.confidence * 0.15;

    // 키워드 개수에 따른 점수
    final int keywordCount = _extractKeywords(fullText, keywords).length;
    score += (keywordCount / 10) * 0.15;

    // 텍스트 길이에 따른 점수 (너무 짧지도 길지도 않게)
    final int textLength = fullText.length;
    if (textLength > 100 && textLength < 1000) {
      score += 0.1;
    }

    // 최신성 점수 (createdAt이 최근일수록 높은 점수)
    try {
      final DateTime createdAt = DateTime.parse(news.createdAt);
      final int daysDiff = DateTime.now().difference(createdAt).inDays;
      if (daysDiff == 0) {
        score += 0.1; // 오늘 뉴스
      } else if (daysDiff <= 3){
        score += 0.05; // 3일 이내
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
    this.keywords,
  });

  final SendPort sendPort;
  final List<News> newsList;
  final KeywordListResponse? keywords;
}