import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/persian_digits.dart';

/// Compact, theme-aware progress indicator for learner level and XP.
class XPBar extends StatelessWidget {
  final int level;
  final int xp;
  final double progress;
  final bool compact;

  const XPBar({
    super.key,
    required this.level,
    required this.xp,
    required this.progress,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final safeProgress = progress.clamp(0.0, 1.0).toDouble();

    return Semantics(
      label: 'پیشرفت سطح ${toPersianDigits(level)}',
      value: '${toPersianDigits((safeProgress * 100).round())} درصد',
      child: Row(
        children: [
          Container(
            width: compact ? 30 : 36,
            height: compact ? 30 : 36,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                toPersianDigits(level),
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: compact ? 12 : 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!compact) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'سطح ${toPersianDigits(level)}',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                      ),
                      Text(
                        '${toPersianDigits(xp)} XP',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(end: safeProgress),
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: compact ? 6 : 8,
                      backgroundColor: scheme.outlineVariant.withValues(alpha: .45),
                      valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
