import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/core/services/youtube/models/youtube_model.dart';
import 'package:xrp_monitor/ui/screen/youtube/widget/youtube_player_modal.dart';
import 'package:xrp_monitor/ui/utils/youtube_utils.dart';

class YoutubeCard extends StatelessWidget {
  const YoutubeCard({
    super.key,
    required this.video,
  });

  final YoutubeVideo video;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      child: InkWell(
        onTap: () => _playVideo(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            if (video.thumbnails != null)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
                  child: Image.network(
                    _getBestThumbnailUrl(video.thumbnails!),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 64.w,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            
            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Html(
                    data: video.title,
                    style: {
                      "*": Style(
                        fontSize: FontSize(16.w),
                        fontWeight: FontWeight.bold,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    },
                  ),
                  SizedBox(height: 8.w),
                  if (video.channelName.isNotEmpty) ...[
                    Text(
                      video.channelName,
                      style: TextStyle(
                        fontSize: 14.w,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.w),
                  ],
                  Html(
                    data: video.description,
                    style: {
                      "*": Style(
                        fontSize: FontSize(12),
                        color: Colors.grey[600],
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    },
                  ),
                  SizedBox(height: 8.w),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16.w,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        video.createdAt,
                        style: TextStyle(
                          fontSize: 12.w,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.play_circle_outline,
                        size: 20.w,
                        color: Colors.red[600],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBestThumbnailUrl(YoutubeThumbnails thumbnails) {
    // 가장 좋은 품질부터 순서대로 시도
    if (thumbnails.high != null && thumbnails.high!.url.isNotEmpty) {
      return thumbnails.high!.url;
    } else if (thumbnails.medium != null && thumbnails.medium!.url.isNotEmpty) {
      return thumbnails.medium!.url;
    } else if (thumbnails.defaultThumbnail != null && thumbnails.defaultThumbnail!.url.isNotEmpty) {
      return thumbnails.defaultThumbnail!.url;
    }
    return ''; // 모든 썸네일이 없는 경우
  }

  void _playVideo(BuildContext context) {
    String? videoId;
    
    // 1. 먼저 모델의 videoId 필드 확인
    if (video.videoId.isNotEmpty && YoutubeUtils.isValidVideoId(video.videoId)) {
      videoId = video.videoId;
    } 
    // 2. originalLink에서 video ID 추출 시도
    else if (video.originalLink.isNotEmpty) {
      videoId = YoutubeUtils.extractVideoId(video.originalLink);
    }

    if (videoId != null && YoutubeUtils.isValidVideoId(videoId)) {
      YoutubePlayerModal.show(
        context,
        videoId: videoId,
        title: video.title.isNotEmpty ? video.title : null,
      );
    } else {
      // video ID를 찾을 수 없는 경우 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('동영상을 재생할 수 없습니다.'),
        ),
      );
    }
  }
}