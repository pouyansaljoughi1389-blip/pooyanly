import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/p_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Brand hero
              Container(
                height: 286,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.24),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -62,
                      left: -42,
                      child: _GlowCircle(size: 190, opacity: 0.10),
                    ),
                    Positioned(
                      bottom: -86,
                      right: -36,
                      child: _GlowCircle(size: 210, opacity: 0.12),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 94,
                            height: 94,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.16),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                'assets/images/app_icon.jpg',
                                width: 94,
                                height: 94,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'POUYANLY',
                            style: TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 31,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'یادگیری انگلیسی، هوشمند و لذت‌بخش',
                            style: TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 13,
                              color: Color(0xE6FFFFFF),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.24),
                              ),
                            ),
                            child: const Text(
                              'از اولین کلمه تا مکالمه روان',
                              style: TextStyle(
                                fontFamily: 'Vazirmatn',
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'هر روز کمی بهتر شو',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'یک مسیر یادگیری متناسب با هدف و سطح خودت بساز.',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 13,
                  height: 1.7,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              const _FeatureTile(
                icon: Icons.route_rounded,
                color: AppColors.primary,
                title: 'مسیر یادگیری شخصی',
                subtitle: 'درس‌ها متناسب با سطح و هدف تو چیده می‌شوند.',
              ),
              const SizedBox(height: 10),
              const _FeatureTile(
                icon: Icons.local_fire_department_rounded,
                color: AppColors.streakColor,
                title: 'انگیزه و استمرار',
                subtitle: 'با XP، امتیاز و زنجیره مطالعه پیشرفتت را ببین.',
              ),
              const SizedBox(height: 10),
              const _FeatureTile(
                icon: Icons.psychology_alt_rounded,
                color: AppColors.secondary,
                title: 'مرور هوشمند',
                subtitle: 'واژه‌ها را در زمان مناسب دوباره تمرین کن.',
              ),
              const SizedBox(height: 24),
              PButton(
                label: 'شروع یادگیری',
                onPressed: () => context.go('/account'),
                icon: Icons.arrow_forward_rounded,
              ),
              const SizedBox(height: 10),
              PButton(
                label: 'قبلاً ثبت‌نام کرده‌ام',
                outlined: true,
                onPressed: () => context.go('/account'),
              ),
              const SizedBox(height: 16),
              Text(
                'ساخت پروفایل  •  مسیر شخصی‌سازی‌شده',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _GlowCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _FeatureTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.55),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.11),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 11,
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
