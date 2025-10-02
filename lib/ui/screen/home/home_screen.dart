import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xrp_monitor/core/route/app_router.gr.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/widgets/appbar/default_bottom_bar.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'home_screen.controller.dart';

@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeScreenController controller = useWidgetController(() => HomeScreenController(ref: ref), context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: 'HOME'),
      body: Center(
        child: Container(
          child: Text('HOME'),
        ),
      ),
    );
  }
}
