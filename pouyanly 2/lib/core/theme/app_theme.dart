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
        ? AppColors.backgroundDarkRole
        : AppColors.backgroundLightRole;
    final surface = isDark
        ? AppColors.surfaceDarkRole
        : AppColors.surfaceLightRole;
    final card = isDark
        ? AppColors.cardDarkRole
        : AppColors.cardLightRole;
    final foreground = isDark
        ? AppColors.foregroundDarkRole
        : AppColors.foregroundLightRole;
    final secondaryText = isDark
        ? AppColors.secondaryTextDarkRole
        : AppColors.secondaryTextLightRole;
    final outline = isDark
        ? AppColors.outlineDarkRole
        : AppColors.outlineLightRole;

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
      fontFamily: AppDesignTokens.fontFamily,
    ).textTheme;

    final textTheme = baseText.copyWith(
      displayLarge: baseText.displayLarge?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontWeight: FontWeight.w800,
        color: foreground,
        height: 1.18,
      ),
      displayMedium: baseText.displayMedium?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontWeight: FontWeight.w800,
        color: foreground,
        height: 1.2,
      ),
      headlineMedium: baseText.headlineMedium?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontWeight: FontWeight.w800,
        color: foreground,
        height: 1.22,
      ),
      headlineSmall: baseText.headlineSmall?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontWeight: FontWeight.w800,
        color: foreground,
        height: 1.25,
      ),
      titleSmall: baseText.titleSmall?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontSize: AppDesignTokens.fontBody,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      titleLarge: baseText.titleLarge?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontSize: AppDesignTokens.fontTitle,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      titleMedium: baseText.titleMedium?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontSize: AppDesignTokens.fontSubtitle,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      bodyLarge: baseText.bodyLarge?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontSize: AppDesignTokens.fontSubtitle,
        height: 1.65,
        color: foreground,
      ),
      bodyMedium: baseText.bodyMedium?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontSize: AppDesignTokens.fontBody,
        height: 1.6,
        color: foreground,
      ),
      bodySmall: baseText.bodySmall?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontSize: AppDesignTokens.fontCaption,
        height: 1.5,
        color: secondaryText,
      ),
      labelLarge: baseText.labelLarge?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontSize: AppDesignTokens.fontBody,
        fontWeight: FontWeight.w700,
        color: foreground,
      ),
      labelMedium: baseText.labelMedium?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontSize: AppDesignTokens.fontCaption,
        fontWeight: FontWeight.w600,
        color: secondaryText,
      ),
      labelSmall: baseText.labelSmall?.copyWith(
        fontFamily: AppDesignTokens.fontFamily,
        fontSize: AppDesignTokens.fontMicro,
        fontWeight: FontWeight.w500,
        color: secondaryText,
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
      fontFamily: AppDesignTokens.fontFamily,
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
        elevation: AppDesignTokens.elevationNone,
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
          minimumSize: const Size(AppDesignTokens.minTouchTarget, AppDesignTokens.minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesignTokens.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontFamily: AppDesignTokens.fontFamily,
            fontSize: AppDesignTokens.fontBody,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: shape,
          textStyle: const TextStyle(
            fontFamily: AppDesignTokens.fontFamily,
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
            fontFamily: AppDesignTokens.fontFamily,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(AppDesignTokens.minTouchTarget, AppDesignTokens.minTouchTarget),
          textStyle: const TextStyle(
            fontFamily: AppDesignTokens.fontFamily,
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
          fontFamily: AppDesignTokens.fontFamily,
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
          fontFamily: AppDesignTokens.fontFamily,
          fontSize: AppDesignTokens.fontCaption,
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
          fontFamily: AppDesignTokens.fontFamily,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppDesignTokens.fontFamily,
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
          fontFamily: AppDesignTokens.fontFamily,
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
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF302D40) : const Color(0xFF292538),
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusSmall),
        ),
        textStyle: const TextStyle(
          fontFamily: AppDesignTokens.fontFamily,
          color: Colors.white,
          fontSize: AppDesignTokens.fontCaption,
        ),
        waitDuration: const Duration(milliseconds: 500),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: const WidgetStatePropertyAll(false),
        thickness: const WidgetStatePropertyAll(4),
        radius: const Radius.circular(AppDesignTokens.radiusPill),
        thumbColor: WidgetStatePropertyAll(
          secondaryText.withValues(alpha: .45),
        ),
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
