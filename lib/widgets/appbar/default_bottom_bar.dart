import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DefaultBottomBar extends HookConsumerWidget {
  const DefaultBottomBar({super.key, this.currentIndex, this.onSelectIndex});

  final int? currentIndex;
  final void Function(int index)? onSelectIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TabsRouter tabRouter = AutoTabsRouter.of(context);

    Color _color(bool active) => active ? CommonColors.mainNavy : CommonColors.mainNavy.withOpacity(0.4);
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(
            size: 30.w,
            color: CommonColors.black
        ),
        unselectedIconTheme: IconThemeData(
            size: 24.w,
            color: CommonColors.black
        ), // 비선택 아이콘 크기
        selectedItemColor: CommonColors.black,      // 라벨 색상
        unselectedItemColor: CommonColors.black,
        currentIndex: tabRouter.activeIndex,
        onTap: (index){
          tabRouter.setActiveIndex(index);
        },
        items:  [
          BottomNavigationBarItem(
              icon: FaIcon(
                  FontAwesomeIcons.house,
                  color: _color(tabRouter.activeIndex == 0), // ✅ 0번 탭이면 활성
                  size: 20.w),
              label: 'HOME'
          ),
          BottomNavigationBarItem(

            icon: FaIcon(FontAwesomeIcons.xTwitter,
                color: _color(tabRouter.activeIndex == 1), // ✅ 0번 탭이면 활성
                size: 20.w),
            label: 'Trump',
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.youtube,
                  color: _color(tabRouter.activeIndex == 2), // ✅ 1번 탭이면 활성
                  size: 20.w),
              label: 'YOUTUBE'
          ),
          BottomNavigationBarItem(
              icon: FaIcon(
                  FontAwesomeIcons.newspaper,
                  color: _color(tabRouter.activeIndex == 3), // ✅ 2번 탭이면 활성
                  size: 20.w),
              label: 'NEWS'
          ),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user,
                  color: _color(tabRouter.activeIndex == 4), // ✅ 3번 탭이면 활성
                  size: 20.w),
              label: 'PROFILE'
          ),

        ]
    );
  }
}
