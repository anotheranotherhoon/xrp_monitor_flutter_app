import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/constants/strings.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
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
      decoration: BoxDecoration(
        color: CommonColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.w),
        ),
      ),
      child: Column(
        children: [
          // 모달 핸들
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.w),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: CommonColors.grey400,
              borderRadius: BorderRadius.circular(2.w),
            ),
          ),
          
          // 헤더
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? 'YouTube Video',
                    style: TextStyle(
                      fontSize: 18.w,
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
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
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
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.videoInfo,
                    style: TextStyle(
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.w),
                  _buildInfoRow('Video ID', videoId),
                  SizedBox(height: 8.w),
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


  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.w,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14.w,
              color: CommonColors.grey600,
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
}
