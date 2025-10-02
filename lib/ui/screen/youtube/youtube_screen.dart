import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/widgets/appbar/default_bottom_bar.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'youtube_screen.controller.dart';

@RoutePage()
class YoutubeScreen extends HookConsumerWidget {
  const YoutubeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final YoutubeScreenController controller = useWidgetController(() => YoutubeScreenController(ref: ref), context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: 'YOUTUBE'),
      body: Center(
        child: Container(
          child: Text('YOUTUBE'),
        ),
      ),
      );
  }
}


