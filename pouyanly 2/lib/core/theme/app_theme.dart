import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark  => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary:          AppColors.primary,
      onPrimary:        Colors.white,
      primaryContainer: isDark ? AppColors.primaryDark : AppColors.primaryLight,
      onPrimaryContainer: isDark ? Colors.white : AppColors.primaryDark,
      secondary:        AppColors.secondary,
      onSecondary:      Colors.white,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.secondaryDark,
      error:            AppColors.error,
      onError:          Colors.white,
      surface:          isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      onSurface:        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      surfaceContainerHighest: isDark ? AppColors.cardDark : AppColors.cardLight,
      onSurfaceVariant: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      outline:          isDark ? AppColors.dividerDark : AppColors.dividerLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      fontFamily: 'Vazirmatn',

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        titleTextStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: isDark ? Colors.black54 : AppColors.primary.withOpacity(0.10),
        surfaceTintColor: Colors.transparent,
        color: isDark ? AppColors.cardDark.withOpacity(0.78) : AppColors.cardLight.withOpacity(0.78),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
        ),
      ),

      // ── ElevatedButton ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: AppColors.primary.withOpacity(0.22),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ── OutlinedButton ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // ── TextButton ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── InputDecoration ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
      ),

      // ── BottomNavigationBar ──
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 10, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 10),
        elevation: 8,
      ),

      // ── Chip ──
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.backgroundLight,
        labelStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 12,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // ── Text ──
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w800, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        displayMedium: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        titleLarge: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700, fontSize: 20, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        titleMedium: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w600, fontSize: 16, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        bodyLarge: TextStyle(fontFamily: 'Vazirmatn', fontSize: 16, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        bodyMedium: TextStyle(fontFamily: 'Vazirmatn', fontSize: 14, color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        bodySmall: TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        labelLarge: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700, fontSize: 14),
      ),

      dialogTheme: DialogThemeData(backgroundColor: isDark ? AppColors.cardDark.withOpacity(0.96) : AppColors.cardLight.withOpacity(0.96), surfaceTintColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),

      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        thickness: 1,
      ),
    );
  }
}
