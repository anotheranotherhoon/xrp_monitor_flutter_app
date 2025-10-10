import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/core/services/news/models/analyzed_news_model.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/core/services/news/isolates/news_analysis_isolate.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/utils/url_utils.dart';

@RoutePage()
class NewsAnalysisScreen extends HookConsumerWidget {
  const NewsAnalysisScreen({
    super.key,
    this.newsData,
  });

  final List<News>? newsData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    final analyzedNews = useState<List<AnalyzedNews>>([]);
    final processingTime = useState<String>('');

    Future<void> loadAnalyzedNews() async {
      // 전달받은 뉴스 데이터가 없으면 리턴
      if (newsData == null || newsData!.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('분석할 뉴스 데이터가 없습니다')),
          );
        }
        return;
      }

      isLoading.value = true;
      try {
        // 전달받은 뉴스 데이터를 Isolate에서 직접 분석
        final analysisResult = await NewsAnalysisIsolate.analyzeNewsAsync(newsData!);
        
        analyzedNews.value = analysisResult.analyzedNews;
        processingTime.value = '분석 완료 (${analysisResult.processingTimeMs}ms)';
        
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('분석 실패: $e')),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    // 화면 로드 시 자동으로 분석 시작
    useEffect(() {
      if (newsData != null && newsData!.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          loadAnalyzedNews();
        });
      }
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('뉴스 분석 데모'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading.value ? null : loadAnalyzedNews,
          ),
        ],
      ),
      body: Column(
        children: [
          // 통계 헤더
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatCard(
                  title: '전체',
                  count: analyzedNews.value.length,
                  color: Colors.blue,
                ),
                _StatCard(
                  title: '긍정',
                  count: analyzedNews.value
                      .where((news) => news.sentiment.type == SentimentType.positive)
                      .length,
                  color: Colors.green,
                ),
                _StatCard(
                  title: '부정',
                  count: analyzedNews.value
                      .where((news) => news.sentiment.type == SentimentType.negative)
                      .length,
                  color: Colors.red,
                ),
                _StatCard(
                  title: '중립',
                  count: analyzedNews.value
                      .where((news) => news.sentiment.type == SentimentType.neutral)
                      .length,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          
          // 처리 시간 표시
          if (processingTime.value.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.green[50],
              child: Text(
                processingTime.value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ),

          // 뉴스 리스트
          Expanded(
            child: isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : analyzedNews.value.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.article, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text('분석할 뉴스가 없습니다'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: loadAnalyzedNews,
                              child: const Text('뉴스 분석 시작'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: analyzedNews.value.length,
                        itemBuilder: (context, index) {
                          final news = analyzedNews.value[index];
                          return _NewsAnalysisCard(news: news);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _NewsAnalysisCard extends StatelessWidget {
  final AnalyzedNews news;

  const _NewsAnalysisCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CommonColors.grey300,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => UrlUtils.launchUrl(news.originalNews.originalLink),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목과 중요도 점수
              Row(
                children: [
                  Expanded(
                    child: Html(
                      data: news.originalNews.title,
                      style: {
                        "*": Style(
                          fontSize: FontSize(18.w),
                          fontWeight: FontWeight.bold,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                        ),
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getImportanceColor(news.importanceScore),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(news.importanceScore * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 설명
              Html(
                data: news.originalNews.description,
                style: {
                  "*": Style(
                    fontSize: FontSize(18.w),
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                  ),
                },
              ),
              const SizedBox(height: 12),

              // 감성분석 결과
              Row(
                children: [
                  Icon(
                    _getSentimentIcon(news.sentiment.type),
                    color: _getSentimentColor(news.sentiment.type),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getSentimentText(news.sentiment.type),
                    style: TextStyle(
                      color: _getSentimentColor(news.sentiment.type),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '신뢰도: ${(news.sentiment.confidence * 100).toInt()}%',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // 키워드
              if (news.keywords.isNotEmpty) ...[
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: news.keywords.map((keyword) =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        keyword,
                        style: const TextStyle(fontSize: 10, color: Colors.blue),
                      ),
                    ),
                  ).toList(),
                ),
                const SizedBox(height: 8),
              ],

              // 읽기 시간
              Text(
                '읽기 시간: ${news.readingTimeMinutes}분',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getImportanceColor(double score) {
    if (score >= 0.7) return Colors.red;
    if (score >= 0.5) return Colors.orange;
    return Colors.grey;
  }

  IconData _getSentimentIcon(SentimentType type) {
    switch (type) {
      case SentimentType.positive:
        return Icons.sentiment_very_satisfied;
      case SentimentType.negative:
        return Icons.sentiment_very_dissatisfied;
      case SentimentType.neutral:
        return Icons.sentiment_neutral;
    }
  }

  Color _getSentimentColor(SentimentType type) {
    switch (type) {
      case SentimentType.positive:
        return Colors.green;
      case SentimentType.negative:
        return Colors.red;
      case SentimentType.neutral:
        return Colors.grey;
    }
  }

  String _getSentimentText(SentimentType type) {
    switch (type) {
      case SentimentType.positive:
        return '긍정';
      case SentimentType.negative:
        return '부정';
      case SentimentType.neutral:
        return '중립';
    }
  }
}