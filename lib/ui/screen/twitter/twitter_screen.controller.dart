part of 'twitter_screen.dart';


class TwitterScreenController extends ConsumerWidgetController<TwitterScreen> {

  TwitterScreenController({required super.ref});


  final SyncLock _lock = SyncLock();

  @override
  void build(BuildContext context) {

    super.build(context);
  }

  Future<void> _loadMoreTweet () async{
    await _lock.protect(() async {
      await ref.read(twitterViewModelProvider.notifier).getNextTweet();
    });
  }

}


