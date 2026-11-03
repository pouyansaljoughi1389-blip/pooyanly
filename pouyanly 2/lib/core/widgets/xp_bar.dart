import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class XPBar extends StatelessWidget {
  final int level;
  final int xp;
  final double progress; // 0.0 to 1.0
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
    return Row(
      children: [
        // Level badge
        Container(
          width: compact ? 30 : 36,
          height: compact ? 30 : 36,
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$level',
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

        // XP bar + label
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!compact) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سطح $level',
                      style: const TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '$xp XP',
                      style: const TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 11,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: compact ? 6 : 8,
                  backgroundColor: AppColors.dividerLight,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
