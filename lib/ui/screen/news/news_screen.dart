import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:xrp_monitor/core/services/news/news_service.dart';
import 'package:xrp_monitor/ui/screen/news/view_models/news_view_model.dart';
import 'package:xrp_monitor/ui/screen/news/models/news_state.dart';
import 'package:xrp_monitor/core/services/news/models/news_model.dart';
import 'package:xrp_monitor/ui/screen/news/widget/news_card.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/ui/utils/url_utils.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'news_screen.controller.dart';

@RoutePage()
class NewsScreen extends HookConsumerWidget {
  const NewsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NewsScreenController controller = useWidgetController(() => NewsScreenController(ref: ref), context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: 'NEWS'),
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
                              'Loading more news...',
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
                'Error: $error',
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


