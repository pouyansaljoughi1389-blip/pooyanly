import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/core/theme/app_colors.dart';

double _whiteContrast(Color background) {
  return 1.05 / (background.computeLuminance() + 0.05);
}

void main() {
  test('brand gradient stops support readable white foreground text', () {
    final gradients = [
      AppColors.primaryGradient,
      AppColors.successGradient,
      AppColors.heroGradient,
      AppColors.warmGradient,
    ];

    for (final gradient in gradients) {
      for (final stop in gradient.colors) {
        expect(
          _whiteContrast(stop),
          greaterThanOrEqualTo(4.5),
          reason: 'Gradient stop $stop must meet WCAG AA normal-text contrast.',
        );
      }
    }
  });

  test('semantic foreground colors meet WCAG AA on light surfaces', () {
    final foregrounds = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.info,
      AppColors.cefrA1,
      AppColors.cefrA2,
      AppColors.cefrB1,
      AppColors.cefrB2,
      AppColors.cefrC1,
      AppColors.cefrC2,
    ];

    for (final foreground in foregrounds) {
      expect(
        _whiteContrast(foreground),
        greaterThanOrEqualTo(4.5),
        reason: 'Foreground $foreground must meet WCAG AA on white.',
      );
    }
  });
}
