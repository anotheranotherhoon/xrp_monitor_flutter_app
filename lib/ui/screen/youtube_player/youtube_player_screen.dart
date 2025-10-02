import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

@RoutePage()
class YoutubePlayerScreen extends HookConsumerWidget {
  const YoutubePlayerScreen({
    super.key,
    required this.videoId,
    this.title,
  });

  final String videoId;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
        loop: false,
      ),
    ));

    useEffect(() {
      controller.loadVideoById(videoId: videoId);
      return () => controller.close();
    }, [videoId]);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title ?? 'YouTube Player',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {
              _enterFullScreen(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(
              controller: controller,
              aspectRatio: 16 / 9,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    'Video ID: ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    videoId,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _enterFullScreen(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenPlayer(
          videoId: videoId,
          title: title,
        ),
      ),
    ).then((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });
  }
}

class _FullScreenPlayer extends HookConsumerWidget {
  const _FullScreenPlayer({
    required this.videoId,
    this.title,
  });

  final String videoId;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: false,
        loop: false,
      ),
    ));

    useEffect(() {
      controller.loadVideoById(videoId: videoId);
      return () => controller.close();
    }, [videoId]);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: YoutubePlayer(
                controller: controller,
                aspectRatio: 16 / 9,
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}