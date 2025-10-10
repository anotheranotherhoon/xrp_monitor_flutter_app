import 'package:intl/intl.dart';
import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/models/api/api_response.dart';
import 'package:xrp_monitor/core/models/common/response_exception.dart';
import 'package:xrp_monitor/core/models/common/response_model.dart';
import 'package:xrp_monitor/core/services/base/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/core/services/news/models/analyzed_news_model.dart';
import 'package:xrp_monitor/core/services/news/isolates/news_analysis_isolate.dart';

part 'news_service.g.dart';


@riverpod
class NewsService extends _$NewsService{

  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);

  @override
  void build() {}

  Future<ResponseModel<List<News>>> getNews(NewsCursorIdParams params) async {
    try {
      final response = await _apiService.get(
        url: '${ApiPath.apiUrl}news/xrp/cursor',
        params: params.toJson(),
      );
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);

        final List<News> data = [];
        for (final Map<String, dynamic> item in apiResponse.result?.list as List) {
          data.add(News.fromJson(item));
        }

        return ResponseModel<List<News>>(
          success: true,
          type: ResponseType.success,
          result: data,
          cursorId: apiResponse.result?.nextCursor
        );
      } else {
        return ResponseModel(success: false, type: ResponseType.alert);
      }
    } catch (err) {
      return throw
        ResponseException(
            ResponseModel(
                success: false,
                type: ResponseType.alert,
                title: '뉴스 정보 조회 실패',
            )
        );
    }
  }

  /// 뉴스를 가져와서 Isolate에서 분석하여 반환
  Future<ResponseModel<List<AnalyzedNews>>> getAnalyzedNews(NewsCursorIdParams params) async {
    try {
      // 1. 먼저 원본 뉴스 데이터를 가져옴
      final newsResponse = await getNews(params);
      
      if (!newsResponse.success || newsResponse.result == null) {
        return ResponseModel(
          success: false, 
          type: ResponseType.alert,
          title: '뉴스 데이터 조회 실패',
        );
      }

      // 2. Isolate에서 뉴스 분석 수행
      final NewsAnalysisResult analysisResult = await NewsAnalysisIsolate.analyzeNewsAsync(newsResponse.result!);

      return ResponseModel<List<AnalyzedNews>>(
        success: true,
        type: ResponseType.success,
        result: analysisResult.analyzedNews,
        cursorId: newsResponse.cursorId,
        content: '분석 완료 (${analysisResult.processingTimeMs}ms)',
      );

    } catch (err) {
      return throw ResponseException(
        ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: '뉴스 분석 실패',
          content: err.toString(),
        )
      );
    }
  }

  /// 뉴스를 감성별로 필터링하여 반환
  Future<ResponseModel<List<AnalyzedNews>>> getNewsBySentiment(
    NewsCursorIdParams params, 
    SentimentType sentimentType
  ) async {
    try {
      final analysisResponse = await getAnalyzedNews(params);
      
      if (!analysisResponse.success || analysisResponse.result == null) {
        return analysisResponse;
      }

      final filteredNews = analysisResponse.result!
          .where((news) => news.sentiment.type == sentimentType)
          .toList();

      return ResponseModel<List<AnalyzedNews>>(
        success: true,
        type: ResponseType.success,
        result: filteredNews,
        cursorId: analysisResponse.cursorId,
        content: '${sentimentType.name} 감성 뉴스 ${filteredNews.length}개',
      );

    } catch (err) {
      return throw ResponseException(
        ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: '감성 필터링 실패',
          content: err.toString(),
        )
      );
    }
  }

  /// 중요도 점수가 높은 뉴스만 반환
  Future<ResponseModel<List<AnalyzedNews>>> getImportantNews(
    NewsCursorIdParams params, 
    {double minImportanceScore = 0.5}
  ) async {
    try {
      final analysisResponse = await getAnalyzedNews(params);
      
      if (!analysisResponse.success || analysisResponse.result == null) {
        return analysisResponse;
      }

      final importantNews = analysisResponse.result!
          .where((news) => news.importanceScore >= minImportanceScore)
          .toList();

      return ResponseModel<List<AnalyzedNews>>(
        success: true,
        type: ResponseType.success,
        result: importantNews,
        cursorId: analysisResponse.cursorId,
        content: '중요 뉴스 ${importantNews.length}개 (점수 >= $minImportanceScore)',
      );

    } catch (err) {
      return throw ResponseException(
        ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: '중요 뉴스 필터링 실패',
          content: err.toString(),
        )
      );
    }
  }

}