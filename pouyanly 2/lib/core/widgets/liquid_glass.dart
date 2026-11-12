import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../theme/app_design_tokens.dart';
import 'premium_icon.dart';

/// A restrained translucent surface for controls and navigation only.
/// Keep lesson copy, vocabulary definitions and long-form content unwrapped.
class LiquidGlass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final bool enableBlur;
  final double blurSigma;
  final Color? tint;
  final bool showHighlight;

  const LiquidGlass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDesignTokens.space3),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(AppDesignTokens.radiusLarge),
    ),
    this.onTap,
    this.enableBlur = false,
    this.blurSigma = AppDesignTokens.blurPopover,
    this.tint,
    this.showHighlight = true,
  }) : assert(blurSigma >= 0 && blurSigma <= 20);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final scheme = theme.colorScheme;
    final baseTint = tint ?? scheme.surfaceContainerHighest;
    final border = scheme.outline.withValues(alpha: dark ? .62 : .72);
    final decoration = BoxDecoration(
      borderRadius: borderRadius,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          baseTint.withValues(alpha: dark ? .84 : .78),
          baseTint.withValues(alpha: dark ? .70 : .66),
        ],
      ),
      border: Border.all(color: border, width: 1),
      boxShadow: [
        BoxShadow(
          color: scheme.shadow.withValues(alpha: dark ? .28 : .045),
          blurRadius: 18,
          offset: const Offset(0, 7),
        ),
        if (showHighlight)
          BoxShadow(
            color: scheme.onSurface.withValues(alpha: dark ? .06 : .035),
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
      ],
    );

    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: content,
      );
    }
    Widget surface = Ink(
      decoration: decoration,
      child: content,
    );

    if (enableBlur && blurSigma > 0) {
      surface = ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: surface,
        ),
      );
    } else {
      surface = ClipRRect(borderRadius: borderRadius, child: surface);
    }

    return Material(
      color: Colors.transparent,
      child: surface,
    );
  }
}

/// Floating, accessible navigation with a single restrained glass layer.
class LiquidGlassNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const LiquidGlassNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.map_rounded, label: 'مسیر'),
    (icon: Icons.home_rounded, label: 'خانه'),
    (icon: Icons.menu_book_rounded, label: 'لغت'),
    (icon: Icons.emoji_events_rounded, label: 'جوایز'),
    (icon: Icons.person_rounded, label: 'من'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    final safeIndex = selectedIndex.clamp(0, _items.length - 1);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: LiquidGlass(
          enableBlur: true,
          blurSigma: AppDesignTokens.blurNavigation,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final active = safeIndex == index;
                return Expanded(
                  child: Semantics(
                    button: true,
                    selected: active,
                    label: item.label,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => onTap(index),
                        child: AnimatedContainer(
                          duration: AppDesignTokens.motionStandard,
                          curve: AppDesignTokens.motionCurve,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: active
                                ? color.withValues(alpha: .13)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: active
                                  ? color.withValues(alpha: .18)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PremiumIcon(
                                icon: item.icon,
                                size: 21,
                                color: active
                                    ? color
                                    : theme.colorScheme.onSurfaceVariant,
                                elevated: active,
                                semanticLabel: item.label,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.label,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Vazirmatn',
                                  fontSize: 10,
                                  height: 1.2,
                                  fontWeight: active
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                  color: active
                                      ? color
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
