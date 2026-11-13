import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/core/theme/app_design_tokens.dart';
import 'package:pouyanly/core/theme/app_theme.dart';

double _contrast(Color foreground, Color background) {
  final a = foreground.computeLuminance();
  final b = background.computeLuminance();
  final lighter = a > b ? a : b;
  final darker = a > b ? b : a;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('POUYANLY Light Mode typography audit', () {
    final theme = AppTheme.light;
    final scheme = AppTheme.light.colorScheme;

    test('every Material 3 text role uses the bundled Persian font', () {
      final styles = [
        theme.textTheme.displayLarge,
        theme.textTheme.displayMedium,
        theme.textTheme.displaySmall,
        theme.textTheme.headlineLarge,
        theme.textTheme.headlineMedium,
        theme.textTheme.headlineSmall,
        theme.textTheme.titleLarge,
        theme.textTheme.titleMedium,
        theme.textTheme.titleSmall,
        theme.textTheme.bodyLarge,
        theme.textTheme.bodyMedium,
        theme.textTheme.bodySmall,
        theme.textTheme.labelLarge,
        theme.textTheme.labelMedium,
        theme.textTheme.labelSmall,
      ];

      for (final style in styles) {
        expect(style?.fontFamily, AppDesignTokens.fontFamily);
      }
      expect(theme.textTheme.bodyMedium?.fontFamily, AppDesignTokens.fontFamily);
    });

    test('semantic normal-text pairs meet WCAG 2.2 AA on actual light surfaces', () {
      final pairs = <(String, Color, Color)>[
        ('primary text / surface', scheme.onSurface, scheme.surface),
        ('primary text / card', scheme.onSurface, scheme.surfaceContainerHighest),
        ('secondary text / surface', scheme.onSurfaceVariant, scheme.surface),
        ('secondary text / card', scheme.onSurfaceVariant, scheme.surfaceContainerHighest),
        ('primary action / surface', scheme.primary, scheme.surface),
        ('primary button label / primary', scheme.onPrimary, scheme.primary),
        ('secondary button label / secondary', scheme.onSecondary, scheme.secondary),
        ('primary-container label', scheme.onPrimaryContainer, scheme.primaryContainer),
        ('error text / surface', scheme.error, scheme.surface),
        ('disabled label / surface', theme.disabledColor, scheme.surface),
      ];

      for (final pair in pairs) {
        expect(
          _contrast(pair.$2, pair.$3),
          greaterThanOrEqualTo(4.5),
          reason: '${pair.$1} must meet 4.5:1 contrast.',
        );
      }
    });

    test('interactive component themes use the shared font and readable colors', () {
      expect(theme.elevatedButtonTheme.style?.textStyle?.resolve({})?.fontFamily,
          AppDesignTokens.fontFamily);
      expect(theme.filledButtonTheme.style?.textStyle?.resolve({})?.fontFamily,
          AppDesignTokens.fontFamily);
      expect(theme.outlinedButtonTheme.style?.textStyle?.resolve({})?.fontFamily,
          AppDesignTokens.fontFamily);
      expect(theme.textButtonTheme.style?.textStyle?.resolve({})?.fontFamily,
          AppDesignTokens.fontFamily);
      expect(theme.chipTheme.labelStyle?.fontFamily, AppDesignTokens.fontFamily);
      expect(theme.inputDecorationTheme.hintStyle?.fontFamily,
          AppDesignTokens.fontFamily);
      expect(theme.dialogTheme.titleTextStyle?.fontFamily,
          AppDesignTokens.fontFamily);
      expect(theme.dialogTheme.contentTextStyle?.fontFamily,
          AppDesignTokens.fontFamily);
      expect(theme.disabledColor, scheme.onSurfaceVariant);
    });

    test('Light and Dark typography retain the Persian font and distinct palettes', () {
      expect(AppTheme.dark.textTheme.bodyMedium?.fontFamily,
          AppDesignTokens.fontFamily);
      expect(AppTheme.dark.disabledColor,
          AppTheme.dark.colorScheme.onSurfaceVariant);
      expect(AppTheme.dark.colorScheme.surface,
          isNot(AppTheme.light.colorScheme.surface));
    });

    testWidgets('RTL content and controls render at narrow width with large text',
        (tester) async {
      tester.view.physicalSize = const Size(320, 720);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(320, 720),
                textScaler: TextScaler.linear(1.8),
              ),
              child: Scaffold(
                body: ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    Text('عنوان فارسی و English mixed',
                        style: AppTheme.light.textTheme.titleLarge),
                    Text('متن توضیحی برای بررسی شکست خطوط و اندازهٔ فونت.',
                        style: AppTheme.light.textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () {},
                      child: const Text('ادامه و ثبت پیشرفت'),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'نام کاربری',
                        hintText: 'نام خود را وارد کن',
                      ),
                    ),
                    const Wrap(
                      spacing: 8,
                      children: [Chip(label: Text('واژگان')), Chip(label: Text('گرامر'))],
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text('محتوای کارت در حالت روز',
                            style: AppTheme.light.textTheme.bodyMedium),
                      ),
                    ),
                    const Dialog(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('پیام راهنما و توضیحات'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('عنوان فارسی و English mixed'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  });
}
