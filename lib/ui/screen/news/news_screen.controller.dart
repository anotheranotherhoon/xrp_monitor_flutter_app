part of 'news_screen.dart';


class NewsScreenController extends ConsumerWidgetController<NewsScreen> {
  NewsScreenController({required super.ref});


  final _lock = SyncLock();

  @override
  void build(BuildContext context) {
    ref.listen(newsViewModelProvider, (prev, next) {
      if (!next.isLoading && next.hasError && next.error is ResponseException) {
        final response = next.error as ResponseException;
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



}


