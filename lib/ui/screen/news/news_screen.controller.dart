part of 'news_screen.dart';

class NewsScreenController extends ConsumerWidgetController<NewsScreen> {
  NewsScreenController({required super.ref});

  /// 분석 화면으로 이동할 때 키워드 데이터와 함께 전달
  KeywordListResponse? get keywords => _cachedKeywords;

  final SyncLock _lock = SyncLock();
  KeywordListResponse? _cachedKeywords;

  @override
  void build(BuildContext context) {
    // 키워드 미리 로드
    _loadKeywords();
    
    ref.listen(newsViewModelProvider, (prev, next) {
      if (!next.isLoading && next.hasError && next.error is ResponseException) {
        final ResponseException response = next.error as ResponseException;
        showDialog<void>(
          context: context,
          builder: (context) => DefaultAlertDialog(
            title: response.response.title,
            content: response.response.content,
          ),
        );
      }
    });
    super.build(context);
  }



  Future<void> _loadMoreNews() async{
    await _lock.protect(() async {
      await ref.read(newsViewModelProvider.notifier).getNextNews();
    });
  }

  /// 키워드 데이터 미리 로드
  Future<void> _loadKeywords() async {
    if (_cachedKeywords != null) return; // 이미 로드된 경우 스킵
    
    try {
      final KeywordService keywordService = ref.read(keywordServiceProvider.notifier);
      final ResponseModel<KeywordListResponse> response = await keywordService.getAllKeywords();
      
      if (response.success && response.result != null) {
        _cachedKeywords = response.result;
      }
    } catch (e) {
      // 키워드 로드 실패는 에러로 표시하지 않음 (기본 키워드 사용)
      debugPrint('키워드 로드 실패: $e');
    }
  }



}


