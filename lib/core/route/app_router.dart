import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.gr.dart';
import 'auth_guard.dart';

class AppReevaluateNotifier with ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

AppRouter? _appRouter;

AppRouter? getAppRouterSafe() => _appRouter;
AppRouter getAppRouter() => _appRouter!;

final appRouterProvider = Provider<AppRouter>((ref) {
  _appRouter ??= AppRouter(ref);
  return _appRouter!;
});

final appReevaluateNotifierProvider =
ChangeNotifierProvider((ref) => AppReevaluateNotifier());

/// ----------------------------
/// AppRouter
/// ----------------------------
///
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter(this.ref);

  final Ref ref;

  List<AutoRouteGuard> get authGuards => [
    AuthGuard(ref: ref, fallback: [
      const LoginRoute()]
    ),
  ];

  @override
  List<AutoRoute> get routes => [
    // Authentication routes
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
    ),
    AutoRoute(
      page: SignupRoute.page,
      path: '/signup',
    ),
    
    // XRP Monitor TabsRootScreen 루트
    AutoRoute(
      page: TabsRootRoute.page,
      path: '/',guards: authGuards,
      children: [
        // XRP 가격 차트 및 실시간 모니터링
        AutoRoute(
          page: HomeRoute.page,
          path: 'monitor',
          initial: true,
        ),
        // XRP 관련 뉴스
        AutoRoute(
          page: NewsRoute.page,
          path: 'news',
        ),
        // XRP 관련 트위터
        AutoRoute(
          page: TwitterRoute.page,
          path: 'twitter',
        ),
        // XRP 관련 유튜브
        AutoRoute(
          page: YoutubeRoute.page,
          path: 'videos',
        ),
        // 설정 및 프로필
        AutoRoute(
          page: SettingRoute.page,
          path: 'setting',
        ),
      ],
    ),
  ];
}
