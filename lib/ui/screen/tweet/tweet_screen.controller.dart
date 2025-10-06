part of 'tweet_screen.dart';


class TweetScreenController extends ConsumerWidgetController<TweetScreen> {

  TweetScreenController({required super.ref});


  final _lock = SyncLock();

  @override
  void build(BuildContext context) {

    super.build(context);
  }

  Future<void> _loadMoreTweet () async{
    await _lock.protect(() async {
      await ref.read(tweetViewModelProvider.notifier).getNextTweet();
    });
  }

}


