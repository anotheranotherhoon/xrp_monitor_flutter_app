import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerModal extends HookConsumerWidget {
  const YoutubePlayerModal({
    super.key,
    required this.videoId,
    this.title,
  });

  final String videoId;
  final String? title;

  static void show(
    BuildContext context, {
    required String videoId,
    String? title,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => YoutubePlayerModal(
        videoId: videoId,
        title: title,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
        loop: false,
        enableCaption: true,
        enableJavaScript: true,
        playsInline: true,
        strictRelatedVideos: true,
      ),
    ));

    useEffect(() {
      // 자동 재생 비활성화를 위해 cueVideoById 사용 (loadVideoById 대신)
      controller.cueVideoById(videoId: videoId);
      return () => controller.close();
    }, [videoId]);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 모달 핸들
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? 'YouTube Video',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          
          // 유튜브 플레이어
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: YoutubePlayer(
                  controller: controller,
                  aspectRatio: 16 / 9,
                ),
              ),
            ),
          ),

          // 추가 정보 영역
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '영상 정보',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Video ID', videoId),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'YouTube Link', 
                    'https://www.youtube.com/watch?v=$videoId',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: SelectableText(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
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
        fullscreenDialog: true,
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
        enableCaption: true,
        enableJavaScript: true,
        playsInline: true,
      ),
    ));

    useEffect(() {
      // 전체화면에서는 자동 재생하지 않음
      controller.cueVideoById(videoId: videoId);
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
            // 전체화면에서 플레이 버튼 추가
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFullScreenButton(
                    icon: Icons.play_arrow,
                    onTap: () => controller.playVideo(),
                  ),
                  const SizedBox(width: 20),
                  _buildFullScreenButton(
                    icon: Icons.pause,
                    onTap: () => controller.pauseVideo(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}