import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_design_tokens.dart';

/// Application-wide Material 3 themes. Content surfaces stay calm and solid;
/// translucent glass is reserved for navigation and transient controls.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark
        ? const Color(0xFF10111B)
        : const Color(0xFFF6F5FA);
    final surface = isDark
        ? const Color(0xFF191A27)
        : const Color(0xFFFFFFFF);
    final card = isDark
        ? const Color(0xFF202131)
        : const Color(0xFFFFFFFF);
    final foreground = isDark
        ? const Color(0xFFF4F2FC)
        : const Color(0xFF211D32);
    final secondaryText = isDark
        ? const Color(0xFFB5B1C5)
        : const Color(0xFF6D687C);
    final outline = isDark
        ? const Color(0xFF39374B)
        : const Color(0xFFE7E3EF);

    final seeded = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );
    final scheme = seeded.copyWith(
      primary: isDark ? const Color(0xFFAAA6FF) : AppColors.primary,
      onPrimary: isDark ? const Color(0xFF17152A) : Colors.white,
      primaryContainer: isDark
          ? const Color(0xFF343052)
          : const Color(0xFFEAE8FF),
      onPrimaryContainer: isDark
          ? const Color(0xFFEAE8FF)
          : const Color(0xFF29234E),
      secondary: isDark ? const Color(0xFF72D9C6) : AppColors.secondary,
      onSecondary: isDark ? const Color(0xFF092B25) : Colors.white,
      error: AppColors.error,
      surface: surface,
      onSurface: foreground,
      surfaceContainerHighest: card,
      onSurfaceVariant: secondaryText,
      outline: outline,
      outlineVariant: outline.withValues(alpha: .72),
    );

    final baseText = ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Vazirmatn',
    ).textTheme;

    final textTheme = baseText.copyWith(
      displayLarge: baseText.displayLarge?.copyWith(
        fontFamily: 'Vazirmatn',
        fontWeight: FontWeight.w800,
        color: foreground,
        height: 1.18,
      ),
      displayMedium: baseText.displayMedium?.copyWith(
        fontFamily: 'Vazirmatn',
        fontWeight: FontWeight.w800,
        color: foreground,
        height: 1.2,
      ),
      headlineSmall: baseText.headlineSmall?.copyWith(
        fontFamily: 'Vazirmatn',
        fontWeight: FontWeight.w800,
        color: foreground,
      ),
      titleLarge: baseText.titleLarge?.copyWith(
        fontFamily: 'Vazirmatn',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontFamily: 'Vazirmatn',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      bodyLarge: baseText.bodyLarge?.copyWith(
        fontFamily: 'Vazirmatn',
        fontSize: 16,
        height: 1.65,
        color: foreground,
      ),
      bodyMedium: baseText.bodyMedium?.copyWith(
        fontFamily: 'Vazirmatn',
        fontSize: 14,
        height: 1.6,
        color: foreground,
      ),
      bodySmall: baseText.bodySmall?.copyWith(
        fontFamily: 'Vazirmatn',
        fontSize: 12,
        height: 1.5,
        color: secondaryText,
      ),
      labelLarge: baseText.labelLarge?.copyWith(
        fontFamily: 'Vazirmatn',
        fontWeight: FontWeight.w700,
      ),
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Vazirmatn',
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: background,
        foregroundColor: foreground,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: foreground, size: 23),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLarge),
          side: BorderSide(color: outline.withValues(alpha: .78)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: shape,
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(48, 48),
          side: BorderSide(color: scheme.primary.withValues(alpha: .55)),
          shape: shape,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(44, 44),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.space4,
          vertical: AppDesignTokens.space3,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          color: secondaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
          borderSide: BorderSide(color: scheme.error, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        selectedColor: scheme.primaryContainer,
        labelStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 12,
          color: foreground,
        ),
        side: BorderSide(color: outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSmall),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: scheme.primary,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 10,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(AppDesignTokens.radiusLarge),
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDesignTokens.radiusLarge),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
        ),
        textStyle: textTheme.bodyMedium,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusLarge),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark
            ? const Color(0xFF302D40)
            : const Color(0xFF292538),
        contentTextStyle: const TextStyle(
          fontFamily: 'Vazirmatn',
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: outline,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.primary.withValues(alpha: .12),
        circularTrackColor: scheme.primary.withValues(alpha: .12),
      ),
      iconTheme: IconThemeData(color: foreground),
    );
  }
}
