import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xrp_monitor/core/services/popup/models/popup_model.dart';
import 'package:xrp_monitor/ui/screen/home/widget/home_popup_dialog.dart';

void main() {
  Widget testApp({
    required Future<void> Function() onHideToday,
    required VoidCallback onClose,
    List<PopupModel>? popups,
    Future<void> Function(String url)? onLaunchExternal,
  }) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder:
          (context, _) => MaterialApp(
            home: Builder(
              builder:
                  (context) => Scaffold(
                    body: Center(
                      child: ElevatedButton(
                        onPressed:
                            () => showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (_) => HomePopupDialog(
                                    popups:
                                        popups ??
                                        const <PopupModel>[
                                          PopupModel(
                                            key: 1,
                                            title: '첫 번째',
                                            imageUrl: 'invalid://first',
                                            displayOrder: 1,
                                          ),
                                          PopupModel(
                                            key: 2,
                                            title: '두 번째',
                                            imageUrl: 'invalid://second',
                                            displayOrder: 2,
                                          ),
                                        ],
                                    onHideToday: onHideToday,
                                    onClose: onClose,
                                    onLaunchExternal: onLaunchExternal,
                                  ),
                            ),
                        child: const Text('open'),
                      ),
                    ),
                  ),
            ),
          ),
    );
  }

  testWidgets('shows a swipeable carousel and two action buttons', (
    tester,
  ) async {
    await tester.pumpWidget(testApp(onHideToday: () async {}, onClose: () {}));
    await tester.tap(find.text('open'));
    await tester.pump();

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('오늘 하루 보지 않기'), findsOneWidget);
    expect(find.text('닫기'), findsOneWidget);
  });

  testWidgets('hide today applies to the whole popup dialog', (tester) async {
    var hidden = false;
    await tester.pumpWidget(
      testApp(onHideToday: () async => hidden = true, onClose: () {}),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.tap(find.text('오늘 하루 보지 않기'));
    await tester.pumpAndSettle();

    expect(hidden, isTrue);
    expect(find.byType(HomePopupDialog), findsNothing);
  });

  testWidgets('close only invokes the session close callback', (tester) async {
    var closed = false;
    await tester.pumpWidget(
      testApp(onHideToday: () async {}, onClose: () => closed = true),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.tap(find.text('닫기'));
    await tester.pumpAndSettle();

    expect(closed, isTrue);
    expect(find.byType(HomePopupDialog), findsNothing);
  });

  testWidgets('opens an external URL when a linked popup image is tapped', (
    WidgetTester tester,
  ) async {
    String? launchedUrl;
    await tester.pumpWidget(
      testApp(
        onHideToday: () async {},
        onClose: () {},
        onLaunchExternal: (String url) async => launchedUrl = url,
        popups: const <PopupModel>[
          PopupModel(
            key: 7,
            title: '외부 링크',
            imageUrl: 'invalid://linked',
            displayOrder: 1,
            actionType: PopupActionType.externalLink,
            linkUrl: 'https://example.com/xrp',
          ),
        ],
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('popup-image-7')));

    expect(launchedUrl, 'https://example.com/xrp');
  });

  testWidgets('does not launch a URL for a no-action popup', (
    WidgetTester tester,
  ) async {
    var launchCount = 0;
    await tester.pumpWidget(
      testApp(
        onHideToday: () async {},
        onClose: () {},
        onLaunchExternal: (String url) async => launchCount++,
        popups: const <PopupModel>[
          PopupModel(
            key: 8,
            title: '이동 없음',
            imageUrl: 'invalid://none',
            displayOrder: 1,
          ),
        ],
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey<String>('popup-image-8')));

    expect(launchCount, 0);
  });

  testWidgets('closes automatically when every popup has expired', (
    WidgetTester tester,
  ) async {
    final DateTime endAt = DateTime.now().add(const Duration(seconds: 1));
    await tester.pumpWidget(
      testApp(
        onHideToday: () async {},
        onClose: () {},
        popups: <PopupModel>[
          PopupModel(
            key: 1,
            title: '곧 종료',
            imageUrl: 'invalid://expiring',
            displayOrder: 1,
            endAt: endAt.toUtc().toIso8601String(),
          ),
        ],
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    expect(find.byType(HomePopupDialog), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(HomePopupDialog), findsNothing);
  });
}
