import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Palette ──────────────────────────────────────────────
  static const Color primary        = Color(0xFF5B5FEF);
  static const Color primaryLight   = Color(0xFF898DFF);
  static const Color primaryDark    = Color(0xFF4145C8);

  static const Color secondary      = Color(0xFF08745D);
  static const Color secondaryLight = Color(0xFF55D9C0);
  static const Color secondaryDark  = Color(0xFF065C4B);

  static const Color accent         = Color(0xFFC43F4A);
  static const Color accentLight    = Color(0xFFFF9E9E);
  static const Color accentDark     = Color(0xFF9F2838);

  // ── Semantic Colors ──────────────────────────────────────────────
  static const Color success  = Color(0xFF16834A);
  static const Color warning  = Color(0xFF9A5B00);
  static const Color error    = Color(0xFFB42318);
  static const Color info     = Color(0xFF1D5FA7);

  // ── CEFR Level Colors ────────────────────────────────────────────
  static const Color cefrA1   = Color(0xFF2E7D32);
  static const Color cefrA2   = Color(0xFF4D7C0F);
  static const Color cefrB1   = Color(0xFF1565C0);
  static const Color cefrB2   = Color(0xFF9C27B0);
  static const Color cefrC1   = Color(0xFFA64B00);
  static const Color cefrC2   = Color(0xFFC62828);

  // ── Gamification Colors ──────────────────────────────────────────
  static const Color xpColor     = Color(0xFFFFD700);
  static const Color coinColor   = Color(0xFFFF9500);
  static const Color streakColor = Color(0xFFFF6B35);

  // ── Light Theme Neutrals ─────────────────────────────────────────
  static const Color backgroundLight     = Color(0xFFF5F6FC);
  static const Color surfaceLight        = Color(0xFFFFFFFF);
  static const Color cardLight           = Color(0xFFFFFFFF);
  static const Color textPrimaryLight    = Color(0xFF171B30);
  static const Color textSecondaryLight  = Color(0xFF6B7280);
  static const Color dividerLight        = Color(0xFFE5E7EB);

  // ── Dark Theme Neutrals ──────────────────────────────────────────
  static const Color backgroundDark     = Color(0xFF0D1020);
  static const Color surfaceDark        = Color(0xFF1A1A2E);
  static const Color cardDark           = Color(0xFF202640);
  static const Color textPrimaryDark    = Color(0xFFF1F1FF);
  static const Color textSecondaryDark  = Color(0xFF9CA3AF);
  static const Color dividerDark        = Color(0xFF374151);

  // ── Gradients ────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    // Both stops maintain readable white foreground text in light mode.
    colors: [Color(0xFF5057E8), Color(0xFF4145C8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    // Darker teal stops preserve contrast for white labels and icons.
    colors: [Color(0xFF087F68), Color(0xFF08745D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    // Avoid the low-contrast mint endpoint used behind white hero text.
    colors: [Color(0xFF5057E8), Color(0xFF087A6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFB53A4B), Color(0xFF8F2E47)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF252538)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Helper: CEFR level to color ──────────────────────────────────
  static Color cefrColor(String level) {
    switch (level.toUpperCase()) {
      case 'A1': return cefrA1;
      case 'A2': return cefrA2;
      case 'B1': return cefrB1;
      case 'B2': return cefrB2;
      case 'C1': return cefrC1;
      case 'C2': return cefrC2;
      default:   return primary;
    }
  }
}
