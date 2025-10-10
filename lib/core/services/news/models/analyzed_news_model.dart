// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'news_model.dart';

part 'analyzed_news_model.freezed.dart';
part 'analyzed_news_model.g.dart';

@freezed
abstract class AnalyzedNews with _$AnalyzedNews {
  const factory AnalyzedNews({
    required News originalNews,
    required SentimentAnalysis sentiment,
    required List<String> keywords,
    required double importanceScore,
    @Default([]) List<String> entities,
    @Default(0) int readingTimeMinutes,
  }) = _AnalyzedNews;

  const AnalyzedNews._();

  factory AnalyzedNews.fromJson(Map<String, dynamic> json) => _$AnalyzedNewsFromJson(json);
}

@freezed
abstract class SentimentAnalysis with _$SentimentAnalysis {
  const factory SentimentAnalysis({
    @Default(SentimentType.neutral) SentimentType type,
    @Default(0.0) double score, // -1.0 (매우 부정) ~ 1.0 (매우 긍정)
    @Default(0.0) double confidence, // 0.0 ~ 1.0 (신뢰도)
  }) = _SentimentAnalysis;

  const SentimentAnalysis._();

  factory SentimentAnalysis.fromJson(Map<String, dynamic> json) => _$SentimentAnalysisFromJson(json);
}

enum SentimentType {
  @JsonValue('positive')
  positive,
  @JsonValue('negative')
  negative,
  @JsonValue('neutral')
  neutral,
}

@JsonSerializable()
class NewsAnalysisRequest {
  NewsAnalysisRequest({
    required this.newsList,
  });

  factory NewsAnalysisRequest.fromJson(Map<String, dynamic> json) => _$NewsAnalysisRequestFromJson(json);

  final List<News> newsList;

  Map<String, dynamic> toJson() => _$NewsAnalysisRequestToJson(this);
}

@JsonSerializable()
class NewsAnalysisResult {
  NewsAnalysisResult({
    required this.analyzedNews,
    required this.processingTimeMs,
  });

  factory NewsAnalysisResult.fromJson(Map<String, dynamic> json) => _$NewsAnalysisResultFromJson(json);

  final List<AnalyzedNews> analyzedNews;
  final int processingTimeMs;

  Map<String, dynamic> toJson() => _$NewsAnalysisResultToJson(this);
}