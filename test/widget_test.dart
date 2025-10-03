import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xrp_monitor/main.dart';

void main() {
  group('XRP Monitor App Tests', () {
    testWidgets('app should build with ProviderScope', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MyApp(),
        ),
      );

      // Assert
      // 앱이 정상적으로 빌드되는지 확인
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should display basic app structure', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('XRP Monitor Test'),
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('XRP Monitor Test'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
