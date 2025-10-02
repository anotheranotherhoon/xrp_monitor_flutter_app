import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const DefaultAppBar({super.key, required this.title, this.onBackPressed, this.actions});

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = onBackPressed != null || context.router.canPop();
    return AppBar(
      elevation: 0,
      backgroundColor: CommonColors.white,
      surfaceTintColor: CommonColors.white,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: CommonColors.mainBlack,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: canGoBack
          ? Center(
              child: IconButton(
                onPressed: () {
                  if (onBackPressed != null) {
                    onBackPressed!();
                  } else {
                    context.pop();
                  }
                },
                icon: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  size: 20.w,
                  color: CommonColors.mainBlack,
                ),
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
