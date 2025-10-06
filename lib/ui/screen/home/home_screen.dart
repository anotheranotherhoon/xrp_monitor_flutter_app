import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xrp_monitor/core/constants/api_path.dart';
import 'package:xrp_monitor/core/services/chart/models/candle_model.dart';
import 'package:xrp_monitor/ui/layout/common_style.dart';
import 'package:xrp_monitor/ui/screen/home/models/chart_data.dart';
import 'package:xrp_monitor/ui/screen/home/widget/chart_current_price_card.dart';
import 'package:xrp_monitor/ui/screen/home/widget/chart_graph.dart';
import 'package:xrp_monitor/ui/utils/sync_lock.dart';
import 'package:xrp_monitor/widgets/appbar/default_app_bar.dart';
import 'package:xrp_monitor/constants/app_bar_title.dart';
import 'package:xrp_monitor/widgets/base/widget_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;


part 'home_screen.controller.dart';

@RoutePage()
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useWidgetController(
      () => HomeScreenController(ref: ref), 
      context
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: DefaultAppBar(title: AppBarTitle.xrpMonitor),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: StreamBuilder<ChartData>(
          stream: controller.chartDataStream,
          builder: (context, snapshot) {
            // 로딩 상태
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16.0.w),
                    Text('웹소켓 연결 중...'),
                  ],
                ),
              );
            }
            
            // 에러 상태
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.w,
                      color: Colors.red.shade300,
                    ),
                    SizedBox(height: 16.0.w),
                    Text(
                      '연결 오류가 발생했습니다',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red.shade600,
                      ),
                    ),
                    SizedBox(height: 8.0.w),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(fontSize: 12.0.w),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            
            // 데이터가 없는 상태
            if (!snapshot.hasData) {
              return const Center(
                child: Text('데이터를 기다리는 중...'),
              );
            }
            
            final chartData = snapshot.data!;
            
            return Column(
              children: [
                // 현재 가격 표시
                ChartCurrentPriceCard(currentPrice:chartData.currentPrice),
                SizedBox(height: 20.0.w),
                // 차트
                Expanded(
                  child: ChartGraph(chartData: chartData),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

}
