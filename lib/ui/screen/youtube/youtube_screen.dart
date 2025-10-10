import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:xrp_monitor/constants/strings.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/screen/youtube/view_models/youtube_view_model.dart';
import 'package:xrp_monitor/ui/screen/youtube/models/youtube_state.dart';
import 'package:xrp_monitor/core/services/youtube/models/youtube_model.dart';
import 'package:xrp_monitor/ui/screen/youtube/widget/youtube_card.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/constants/app_bar_title.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/widgets/loading/loading_indicator.dart';
import 'package:xrp_monitor/widgets/common/scroll_to_top_button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'youtube_screen.controller.dart';

@RoutePage()
class YoutubeScreen extends HookConsumerWidget {
  const YoutubeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final YoutubeScreenController controller = useWidgetController(() => YoutubeScreenController(ref: ref), context);
    final scrollController = useScrollController();
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: AppBarTitle.youtube),
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
                    controller: scrollController,
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
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: CommonColors.mainBlack,
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                valueColor: AlwaysStoppedAnimation<Color>(CommonColors.white),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              AppStrings.ytLazyLoad,
                              style: TextStyle(color: CommonColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // 스크롤 탑 버튼
                ScrollToTopButton(
                  scrollController: scrollController,
                  heroTag: "youtube_scroll_top",
                ),
              ],
            );
          }
        },
        loading: () => const LoadingScreen(),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 64.w,
                color: CommonColors.mainRed,
              ),
              SizedBox(height: 16.w),
              Text(
                '비디오를 불러오는 중 오류가 발생했습니다.',
                style: TextStyle(color: CommonColors.mainRed),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


