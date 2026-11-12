import 'package:flutter/material.dart';

/// Shared geometry, spacing and motion tokens for the POUYANLY UI.
class AppDesignTokens {
  AppDesignTokens._();

  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space7 = 32;
  static const double space8 = 40;

  static const double radiusSmall = 12;
  static const double radiusMedium = 18;
  static const double radiusLarge = 24;
  static const double radiusPill = 999;

  static const double blurNavigation = 12;
  static const double blurPopover = 10;

  static const Duration motionFast = Duration(milliseconds: 140);
  static const Duration motionStandard = Duration(milliseconds: 220);
  static const Duration motionEmphasis = Duration(milliseconds: 320);

  static const Curve motionCurve = Curves.easeOutCubic;
}
