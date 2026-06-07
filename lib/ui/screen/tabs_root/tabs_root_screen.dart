import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xrp_monitor/widgets/appbar/default_bottom_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/service/network/network_status_service.dart';
import 'package:xrp_monitor/widgets/common/offline_status_banner.dart';

@RoutePage()
class TabsRootScreen extends HookConsumerWidget {
  const TabsRootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(networkStatusProvider);

    return AutoTabsRouter(
      routes: const [
        HomeRoute(), // XRP 모니터링
        TwitterRoute(), // CryptoCompare 기사
        YoutubeRoute(), // XRP 유튜브
        NewsRoute(), // XRP 뉴스
        SettingRoute(), // 설정
      ],
      builder: (context, child) {
        return Scaffold(
          body: child, // 현재 활성 탭 화면
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isOnline) const NetworkOfflineBar(),
              DefaultBottomBar(),
            ],
          ),
        );
      },
    );
  }
}
