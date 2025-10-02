part of 'youtube_screen.dart';


class YoutubeScreenController extends ConsumerWidgetController<YoutubeScreen> {
  YoutubeScreenController({required super.ref});

  final _lock = SyncLock();

  @override
  void build(BuildContext context) {
    super.build(context);
  }

  Future<void> _loadMoreVideos () async{
    await _lock.protect(() async {
      await ref.read(youtubeViewModelProvider.notifier).getNextYoutubeVideos();
    });
  }
}


