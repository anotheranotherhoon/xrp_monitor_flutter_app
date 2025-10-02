part of 'news_screen.dart';


class NewsScreenController extends ConsumerWidgetController<NewsScreen> {
  NewsScreenController({required super.ref});


  final _lock = SyncLock();

  @override
  void build(BuildContext context) {

    super.build(context);
  }



  Future<void> _loadMoreNews() async{
    await ref.read(newsViewModelProvider.notifier).getNextNews();
  }



}


