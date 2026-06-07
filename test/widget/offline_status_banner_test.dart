import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xrp_monitor/widgets/common/offline_status_banner.dart';

void main() {
  Widget testApp(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
    );
  }

  testWidgets('shows cached data message while offline', (tester) async {
    await tester.pumpWidget(
      testApp(const OfflineStatusBanner(hasPendingSync: false)),
    );

    expect(find.textContaining('저장된 데이터를 표시'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
  });

  testWidgets('shows automatic sync message for pending changes', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(const OfflineStatusBanner(hasPendingSync: true)),
    );

    expect(find.textContaining('연결되면 자동 동기화'), findsOneWidget);
  });

  testWidgets('shows global network offline message', (tester) async {
    await tester.pumpWidget(testApp(const NetworkOfflineBar()));

    expect(find.textContaining('네트워크 연결 없음'), findsOneWidget);
  });
}
