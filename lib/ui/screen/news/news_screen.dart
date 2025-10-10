import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:xrp_monitor/constants/strings.dart';
import 'package:xrp_monitor/core/models/common/response_exception.dart';
import 'package:xrp_monitor/core/services/news/news_service.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/screen/news/view_models/news_view_model.dart';
import 'package:xrp_monitor/ui/screen/news/models/news_state.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/ui/screen/news/widget/news_card.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/ui/utils/url_utils.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/constants/app_bar_title.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/widgets/loading/loading_indicator.dart';
import 'package:xrp_monitor/widgets/dialog/defalut_alert_dialog.dart';
import 'package:xrp_monitor/widgets/dialog/vertical_two_button_dialog.dart';
import 'package:xrp_monitor/widgets/common/scroll_to_top_button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'news_screen.controller.dart';

@RoutePage()
class NewsScreen extends HookConsumerWidget {
  const NewsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NewsScreenController controller = useWidgetController(() => NewsScreenController(ref: ref), context);
    final scrollController = useScrollController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(
        title: AppBarTitle.news,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              // 현재 로드된 뉴스 데이터 가져오기
              final newsAsync = ref.read(newsViewModelProvider);
              newsAsync.when(
                data: (newsState) {
                  if (newsState.item.isNotEmpty) {
                    context.router.root.push(NewsAnalysisRoute(newsData: newsState.item));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('분석할 뉴스가 없습니다')),
                    );
                  }
                },
                loading: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('뉴스를 로드 중입니다...')),
                  );
                },
                error: (error, stack) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('뉴스 로드 실패: $error')),
                  );
                },
              );
            },
            tooltip: '뉴스 분석 데모',
          ),
        ],
      ),
      body: ref.watch(newsViewModelProvider).when(
        data: (NewsState newsState){
          if(newsState.item.isEmpty){
            return const Center(
              child: Text('No news available'),
            );
          }else{
            return Stack(
              children: [
                LazyLoadScrollView(
                  onEndOfPage: () => controller._loadMoreNews(),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final News news = newsState.item[index];
                            return  NewsCard(news: news);
                          },
                          childCount: newsState.item.length,
                        ),
                      ),
                    ],
                  ),
                ),
                if (newsState.isFetching)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: CommonColors.mainBlack.withValues(alpha: 0.5),
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
                              AppStrings.newsLazyLoad,
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
                  heroTag: "news_scroll_top",
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
                '확인중입니다.',
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


