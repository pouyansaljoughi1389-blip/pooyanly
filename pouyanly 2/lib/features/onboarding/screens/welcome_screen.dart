import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/p_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── Hero Top ──
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🦁', style: TextStyle(fontSize: 60)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'POUYANLY',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'یادگیری هوشمند زبان انگلیسی',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 15,
                        color: Colors.white80,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Features + Buttons ──
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                children: [
                  _FeatureRow(
                    emoji: '🎯',
                    title: 'مسیر یادگیری شخصی',
                    subtitle: 'برنامه درسی متناسب با سطح و هدف شما',
                  ),
                  const SizedBox(height: 16),
                  _FeatureRow(
                    emoji: '🔥',
                    title: 'سیستم Streak و جوایز',
                    subtitle: 'هر روز یاد بگیر، امتیاز بگیر، پیشرفت کن',
                  ),
                  const SizedBox(height: 16),
                  _FeatureRow(
                    emoji: '🧠',
                    title: 'تکرار فاصله‌دار هوشمند',
                    subtitle: 'کلمات را با SRS برای همیشه به خاطر بسپار',
                  ),
                  const Spacer(),
                  PButton(
                    label: 'شروع یادگیری',
                    onPressed: () => context.go('/onboarding'),
                  ),
                  const SizedBox(height: 12),
                  PButton(
                    label: 'قبلاً ثبت‌نام کرده‌ام',
                    outlined: true,
                    onPressed: () => context.go('/home'),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'رایگان · بدون نیاز به ثبت‌نام اولیه',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _FeatureRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 12,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
