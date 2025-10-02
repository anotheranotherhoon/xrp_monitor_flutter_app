import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:xrp_monitor/ui/screen/youtube/view_models/youtube_view_model.dart';
import 'package:xrp_monitor/ui/screen/youtube/models/youtube_state.dart';
import 'package:xrp_monitor/core/services/youtube/models/youtube_model.dart';
import 'package:xrp_monitor/ui/screen/youtube/widget/youtube_card.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'youtube_screen.controller.dart';

@RoutePage()
class YoutubeScreen extends HookConsumerWidget {
  const YoutubeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final YoutubeScreenController controller = useWidgetController(() => YoutubeScreenController(ref: ref), context);
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: 'YOUTUBE'),
      body: ref.watch(youtubeViewModelProvider).when(
        data: (YoutubeState youtubeState){
          if(youtubeState.item.isEmpty){
            return const Center(
              child: Text('No YouTube videos available'),
            );
          }else{
            return Stack(
              children: [
                LazyLoadScrollView(
                  onEndOfPage: () => controller._loadMoreVideos(),
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final YoutubeVideo video = youtubeState.item[index];
                            return YoutubeCard(video: video);
                          },
                          childCount: youtubeState.item.length,
                        ),
                      ),
                    ],
                  ),
                ),
                if (youtubeState.isFetching)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Loading more videos...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                '비디오를 불러오는 중 오류가 발생했습니다.',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


