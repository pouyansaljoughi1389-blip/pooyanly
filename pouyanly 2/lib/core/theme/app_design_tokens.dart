import 'package:flutter/material.dart';

/// Shared geometry, spacing and motion tokens for the POUYANLY UI.
/// Keep these values semantic so screens do not invent local design scales.
class AppDesignTokens {
  AppDesignTokens._();

  // Spacing: 4 px base scale.
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space7 = 32;
  static const double space8 = 40;
  static const double space9 = 48;
  static const double space10 = 56;
  static const double space11 = 64;

  // Shape language.
  static const double radiusXSmall = 8;
  static const double radiusSmall = 12;
  static const double radiusMedium = 18;
  static const double radiusLarge = 24;
  static const double radiusXLarge = 28;
  static const double radiusPill = 999;

  // Typography: one Persian-first scale shared by all screens.
  static const String fontFamily = 'Vazirmatn';
  static const double fontDisplay = 32;
  static const double fontHeadline = 24;
  static const double fontTitle = 20;
  static const double fontSubtitle = 16;
  static const double fontBody = 14;
  static const double fontCaption = 12;
  static const double fontMicro = 11;

  // Interactive and icon sizing.
  static const double minTouchTarget = 48;
  static const double iconSmall = 16;
  static const double iconMedium = 20;
  static const double iconLarge = 24;
  static const double iconDisplay = 32;
  static const double contentMaxWidth = 640;

  // Elevation and translucency budget.
  static const double elevationNone = 0;
  static const double elevationLow = 1;
  static const double elevationRaised = 3;
  static const double blurNavigation = 12;
  static const double blurPopover = 10;

  // Motion: static by default; use only for state changes and feedback.
  static const Duration motionFast = Duration(milliseconds: 140);
  static const Duration motionStandard = Duration(milliseconds: 220);
  static const Duration motionEmphasis = Duration(milliseconds: 320);
  static const Curve motionCurve = Curves.easeOutCubic;
}
