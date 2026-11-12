import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_design_tokens.dart';

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
    final dark = Theme.of(context).brightness == Brightness.dark;
    final reduceTransparency = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final useBlur = enableBlur && !reduceTransparency && blurSigma > 0;
    final baseTint = tint ?? (dark ? const Color(0xFF25203D) : Colors.white);
    final border = dark
        ? Colors.white.withOpacity(.16)
        : AppColors.primary.withOpacity(.12);

    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            baseTint.withOpacity(dark ? .84 : .78),
            baseTint.withOpacity(dark ? .70 : .66),
          ],
        ),
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(dark ? .20 : .055),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
          if (showHighlight)
            BoxShadow(
              color: Colors.white.withOpacity(dark ? .07 : .72),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );

    if (useBlur) {
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

    if (onTap == null) return surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: surface,
      ),
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
                                ? color.withOpacity(.13)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: active
                                  ? color.withOpacity(.18)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                size: 22,
                                color: active
                                    ? color
                                    : theme.colorScheme.onSurfaceVariant,
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
