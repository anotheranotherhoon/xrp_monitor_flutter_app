import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:xrp_monitor/constants/strings.dart';
import 'package:xrp_monitor/core/services/twitter/models/twitter_model.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/screen/twitter/models/twitter_state.dart';
import 'package:xrp_monitor/ui/screen/twitter/view_models/twitter_view_model.dart';
import 'package:xrp_monitor/ui/screen/twitter/widget/twitter_card.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/constants/app_bar_title.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:xrp_monitor/widgets/loading/loading_indicator.dart';
import 'package:xrp_monitor/widgets/common/scroll_to_top_button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'twitter_screen.controller.dart';


@RoutePage()
class TwitterScreen extends HookConsumerWidget {
  const TwitterScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TwitterScreenController controller = useWidgetController(() => TwitterScreenController(ref: ref), context);
    final scrollController = useScrollController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: AppBarTitle.twitter),
      body: ref.watch(twitterViewModelProvider).when(
        data: (TwitterState twitterState) {
          if (twitterState.item.isEmpty) {
            return const Center(
              child: Text(AppStrings.tweetEmpty),
            );
          } else {
            return Stack(
              children: [
                LazyLoadScrollView(
                  onEndOfPage: () => controller._loadMoreTweet(),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final Twitter tweet = twitterState.item[index];
                            return TwitterCard(twitter: tweet);
                          },
                          childCount: twitterState.item.length,
                        ),
                      ),
                    ],
                  ),
                ),
                if (twitterState.isFetching)
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
                              AppStrings.twitterLazyLoad,
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
                  heroTag: "twitter_scroll_top",
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
                size: 64,
                color: CommonColors.mainRed,
              ),
              SizedBox(height: 16.w),
              Text(
                AppStrings.tweetLoadError,
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

