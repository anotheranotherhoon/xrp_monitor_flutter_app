import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/screen/tweet/view_models/tweet_view_model.dart';
import 'package:xrp_monitor/ui/screen/tweet/models/tweet_state.dart';
import 'package:xrp_monitor/core/services/tweet/models/tweet_model.dart';
import 'package:xrp_monitor/ui/screen/tweet/widget/tweet_card.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/constants/app_bar_title.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';

part 'tweet_screen.controller.dart';


@RoutePage()
class TweetScreen extends HookConsumerWidget {
  const TweetScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: AppBarTitle.tweet),
      body: ref.watch(tweetViewModelProvider).when(
        data: (TweetState tweetState) {
          if (tweetState.item.isEmpty) {
            return const Center(
              child: Text('No tweets available'),
            );
          } else {
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final Tweet tweet = tweetState.item[index];
                          return TweetCard(tweet: tweet);
                        },
                        childCount: tweetState.item.length,
                      ),
                    ),
                  ],
                ),
                if (tweetState.isFetching)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: CommonColors.black,
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
                              'Loading more tweets...',
                              style: TextStyle(color: CommonColors.white),
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
              Icon(
                Icons.error,
                size: 64,
                color: CommonColors.mainRed,
              ),
              SizedBox(height: 16.w),
              Text(
                '트윗을 불러오는 중 오류가 발생했습니다.',
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


