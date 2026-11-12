import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/core/theme/app_design_tokens.dart';
import 'package:pouyanly/core/theme/app_theme.dart';

void main() {
  group('POUYANLY design system contract', () {
    test('light and dark themes expose complete readable typography', () {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        expect(theme.useMaterial3, isTrue);
        expect(theme.textTheme.bodyMedium?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.displayLarge?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.headlineMedium?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.headlineSmall?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.titleLarge?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.titleMedium?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.titleSmall?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.bodyLarge?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.bodyMedium?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.bodySmall?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.labelLarge?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.labelMedium?.fontFamily, 'Vazirmatn');
        expect(theme.textTheme.labelSmall?.fontFamily, 'Vazirmatn');
      }
    });

    test('interactive controls meet the shared minimum touch target', () {
      const minimum = AppDesignTokens.minTouchTarget;
      expect(minimum, greaterThanOrEqualTo(48));
      expect(
        AppTheme.light.elevatedButtonTheme.style?.minimumSize
            ?.resolve({})?.height,
        minimum,
      );
      expect(
        AppTheme.dark.filledButtonTheme.style?.minimumSize
            ?.resolve({})?.height,
        minimum,
      );
      expect(
        AppTheme.light.textButtonTheme.style?.minimumSize
            ?.resolve({})?.height,
        minimum,
      );
    });

    test('light and dark themes use their intended distinct surfaces', () {
      expect(
        AppTheme.light.scaffoldBackgroundColor,
        isNot(AppTheme.dark.scaffoldBackgroundColor),
      );
      expect(
        AppTheme.light.colorScheme.surface,
        isNot(AppTheme.dark.colorScheme.surface),
      );
      expect(AppTheme.light.colorScheme.onSurface, isNot(Colors.white));
      expect(AppTheme.dark.colorScheme.onSurface, isNot(Colors.black));
    });
  });
}
