import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/core/services/news/models/analyzed_news_model.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/core/services/news/isolates/news_analysis_isolate.dart';
import 'package:xrp_monitor/core/services/keyword/models/keyword_model.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/utils/url_utils.dart';
import 'package:xrp_monitor/widgets/common/scroll_to_top_button.dart';

@RoutePage()
class NewsAnalysisScreen extends HookConsumerWidget {
  const NewsAnalysisScreen({
    super.key,
    this.newsData,
    this.keywords,
  });

  final List<News>? newsData;
  final KeywordListResponse? keywords;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isLoading = useState(false);
    final analyzedNews = useState<List<AnalyzedNews>>([]);
    final processingTime = useState<String>('');
    final selectedFilter = useState<SentimentType?>(null); // null = 전체
    final filteredNews = useState<List<AnalyzedNews>>([]);
    final sortByImportance = useState<bool>(false); // true = 중요도순, false = 시간순
    final scrollController = useScrollController();


    // 뉴스 정렬 함수
    List<AnalyzedNews> sortNews(List<AnalyzedNews> newsList) {
      final sorted = List<AnalyzedNews>.from(newsList);
      if (sortByImportance.value) {
        // 중요도 점수 순 (높은 점수부터)
        sorted.sort((a, b) => b.importanceScore.compareTo(a.importanceScore));
      } else {
        // 시간 순 (최신부터) - 원본 순서 유지
        // 이미 API에서 최신순으로 받아왔으므로 원본 순서 그대로
      }
      return sorted;
    }


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
        // 전달받은 뉴스 데이터를 키워드와 함께 Isolate에서 분석
        final analysisResult = await NewsAnalysisIsolate.analyzeNewsAsync(
          newsData!,
          keywords: keywords,
        );
        
        analyzedNews.value = analysisResult.analyzedNews;
        // 초기 로드시 정렬 적용
        filteredNews.value = sortNews(analysisResult.analyzedNews);
        
        final keywordInfo = keywords != null 
            ? ' (키워드: 긍정 ${keywords!.positiveKeywords.length}, 부정 ${keywords!.negativeKeywords.length}, 중요 ${keywords!.importantKeywords.length})'
            : ' (기본 키워드 사용)';
        processingTime.value = '분석 완료 (${analysisResult.processingTimeMs}ms)$keywordInfo';
        
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


    // 필터링 함수
    void filterNewsBySentiment(SentimentType? sentimentType) {
      selectedFilter.value = sentimentType;
      
      List<AnalyzedNews> baseList;
      if (sentimentType == null) {
        // 전체 표시
        baseList = analyzedNews.value;
      } else {
        // 특정 감성만 필터링
        baseList = analyzedNews.value
            .where((news) => news.sentiment.type == sentimentType)
            .toList();
      }
      
      // 정렬 적용
      filteredNews.value = sortNews(baseList);
      
      // 스크롤을 맨 위로 올리기
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }

    // 정렬 방식 변경 함수
    void toggleSortOrder() {
      sortByImportance.value = !sortByImportance.value;
      // 현재 필터 상태를 유지하며 재정렬
      filterNewsBySentiment(selectedFilter.value);
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
        elevation: 0,
        backgroundColor: CommonColors.white,
        surfaceTintColor: CommonColors.white,
        title: Text('뉴스 분석',
          style: TextStyle(
          fontSize: 16.w,
          color: CommonColors.mainBlack,
          fontWeight: FontWeight.w600,
        ),),
        actions: [
          // 정렬 방식 표시 및 토글 버튼
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Material(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: toggleSortOrder,
                borderRadius: BorderRadius.circular(16),
                splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                highlightColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        sortByImportance.value
                            ? Icons.star  // 중요도순 아이콘 (채워진)
                            : Icons.schedule,  // 최신순 아이콘
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sortByImportance.value ? '중요도순' : '최신순',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.swap_vert,
                        size: 14,
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading.value ? null : loadAnalyzedNews,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
        children: [
          // 통계 헤더 - 클릭 가능한 필터
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _FilterStatCard(
                  title: '전체',
                  count: analyzedNews.value.length,
                  color: Colors.blue,
                  isSelected: selectedFilter.value == null,
                  onTap: () => filterNewsBySentiment(null),
                ),
                _FilterStatCard(
                  title: '긍정',
                  count: analyzedNews.value
                      .where((news) => news.sentiment.type == SentimentType.positive)
                      .length,
                  color: Colors.green,
                  isSelected: selectedFilter.value == SentimentType.positive,
                  onTap: () => filterNewsBySentiment(SentimentType.positive),
                ),
                _FilterStatCard(
                  title: '부정',
                  count: analyzedNews.value
                      .where((news) => news.sentiment.type == SentimentType.negative)
                      .length,
                  color: Colors.red,
                  isSelected: selectedFilter.value == SentimentType.negative,
                  onTap: () => filterNewsBySentiment(SentimentType.negative),
                ),
                _FilterStatCard(
                  title: '중립',
                  count: analyzedNews.value
                      .where((news) => news.sentiment.type == SentimentType.neutral)
                      .length,
                  color: Colors.grey,
                  isSelected: selectedFilter.value == SentimentType.neutral,
                  onTap: () => filterNewsBySentiment(SentimentType.neutral),
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
                : filteredNews.value.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.article, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            Text(
                              selectedFilter.value == null 
                                ? '분석할 뉴스가 없습니다'
                                : '${_getSentimentText(selectedFilter.value!)} 뉴스가 없습니다'
                            ),
                            if (analyzedNews.value.isEmpty) ...[
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: loadAnalyzedNews,
                                child: const Text('뉴스 분석 시작'),
                              ),
                            ]
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: filteredNews.value.length,
                        itemBuilder: (context, index) {
                          final news = filteredNews.value[index];
                          return _NewsAnalysisCard(news: news);
                        },
                      ),
          ),
        ],
      ),
      // 스크롤 탑 버튼
      ScrollToTopButton(
        scrollController: scrollController,
        heroTag: "news_analysis_scroll_top",
      ),
    ],
  ),
    );
  }

  // 감성 텍스트 변환 헬퍼 함수
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

class _FilterStatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterStatCard({
    required this.title,
    required this.count,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : color.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
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
                    fontSize: FontSize(14.w),
                    color: CommonColors.grey600,
                    maxLines: 3,
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