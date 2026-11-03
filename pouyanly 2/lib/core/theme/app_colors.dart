import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Palette ──────────────────────────────────────────────
  static const Color primary        = Color(0xFF6C63FF);
  static const Color primaryLight   = Color(0xFF9D97FF);
  static const Color primaryDark    = Color(0xFF4A42D6);

  static const Color secondary      = Color(0xFF00C896);
  static const Color secondaryLight = Color(0xFF4DDBAF);
  static const Color secondaryDark  = Color(0xFF009E76);

  static const Color accent         = Color(0xFFFF6B6B);
  static const Color accentLight    = Color(0xFFFF9E9E);
  static const Color accentDark     = Color(0xFFD94040);

  // ── Semantic Colors ──────────────────────────────────────────────
  static const Color success  = Color(0xFF2ECC71);
  static const Color warning  = Color(0xFFF39C12);
  static const Color error    = Color(0xFFE74C3C);
  static const Color info     = Color(0xFF3498DB);

  // ── CEFR Level Colors ────────────────────────────────────────────
  static const Color cefrA1   = Color(0xFF4CAF50);
  static const Color cefrA2   = Color(0xFF8BC34A);
  static const Color cefrB1   = Color(0xFF2196F3);
  static const Color cefrB2   = Color(0xFF9C27B0);
  static const Color cefrC1   = Color(0xFFFF9800);
  static const Color cefrC2   = Color(0xFFF44336);

  // ── Gamification Colors ──────────────────────────────────────────
  static const Color xpColor     = Color(0xFFFFD700);
  static const Color coinColor   = Color(0xFFFF9500);
  static const Color streakColor = Color(0xFFFF6B35);

  // ── Light Theme Neutrals ─────────────────────────────────────────
  static const Color backgroundLight     = Color(0xFFF8F7FF);
  static const Color surfaceLight        = Color(0xFFFFFFFF);
  static const Color cardLight           = Color(0xFFFFFFFF);
  static const Color textPrimaryLight    = Color(0xFF1A1A2E);
  static const Color textSecondaryLight  = Color(0xFF6B7280);
  static const Color dividerLight        = Color(0xFFE5E7EB);

  // ── Dark Theme Neutrals ──────────────────────────────────────────
  static const Color backgroundDark     = Color(0xFF0F0F1A);
  static const Color surfaceDark        = Color(0xFF1A1A2E);
  static const Color cardDark           = Color(0xFF252538);
  static const Color textPrimaryDark    = Color(0xFFF1F1FF);
  static const Color textSecondaryDark  = Color(0xFF9CA3AF);
  static const Color dividerDark        = Color(0xFF374151);

  // ── Gradients ────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00C896), Color(0xFF4DDBAF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF00C896)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF9E9E)],
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
