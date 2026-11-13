import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/core/theme/app_theme.dart';
import 'package:pouyanly/core/widgets/app_surface.dart';

void main() {
  group('POUYANLY design system', () {
    test('light and dark themes share Material 3 and Persian typography', () {
      expect(AppTheme.light.useMaterial3, isTrue);
      expect(AppTheme.dark.useMaterial3, isTrue);
      expect(AppTheme.light.fontFamily, 'Vazirmatn');
      expect(AppTheme.dark.fontFamily, 'Vazirmatn');
      expect(AppTheme.light.brightness, Brightness.light);
      expect(AppTheme.dark.brightness, Brightness.dark);
    });

    testWidgets('shared surface and progress bar render in both themes',
        (tester) async {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: const Scaffold(
              body: Padding(
                padding: EdgeInsets.all(16),
                child: AppSurface(
                  child: AppProgressBar(
                    value: 1.4,
                    semanticLabel: 'پیشرفت آزمون',
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AppSurface), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      }
    });
  });
}
