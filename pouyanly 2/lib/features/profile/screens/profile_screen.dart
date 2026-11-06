import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/p_button.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            user.name?.isNotEmpty == true
                                ? user.name![0].toUpperCase()
                                : '🦁',
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.name ?? 'زبان‌آموز',
                        style: const TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'سطح ${user.cefrLevel.label} — ${user.cefrLevel.farsiDescription}',
                          style: const TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                Row(
                  children: [
                    _StatBox('${user.xp}', 'امتیاز XP', '⭐'),
                    const SizedBox(width: 10),
                    _StatBox('${user.streak}', 'روز پیاپی', '🔥'),
                    const SizedBox(width: 10),
                    _StatBox('${user.completedLessonIds.length}', 'درس', '✅'),
                  ],
                ),
                const SizedBox(height: 24),

                // Learning info
                _InfoSection(
                  title: 'اطلاعات یادگیری',
                  children: [
                    _InfoRow('هدف', user.goal?.farsiLabel ?? 'تنظیم نشده', '🎯'),
                    _InfoRow('زمان روزانه',
                        user.dailyStudyTime?.farsiLabel ?? 'تنظیم نشده', '⏱️'),
                    _InfoRow('سطح CEFR', user.cefrLevel.label, '📊'),
                  ],
                ),
                const SizedBox(height: 16),

                // Skill scores
                if (user.skillScores.isNotEmpty) ...[
                  _InfoSection(
                    title: 'نتایج آزمون',
                    children: [
                      if (user.skillScores.containsKey('vocabulary'))
                        _ScoreRow('لغت', user.skillScores['vocabulary']!,
                            AppColors.primary),
                      if (user.skillScores.containsKey('grammar'))
                        _ScoreRow('گرامر', user.skillScores['grammar']!,
                            AppColors.secondary),
                      if (user.skillScores.containsKey('reading'))
                        _ScoreRow('خواندن', user.skillScores['reading']!,
                            AppColors.accent),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Settings
                _InfoSection(
                  title: 'تنظیمات',
                  children: [
                    _SettingRow(
                      icon: Icons.dark_mode_rounded,
                      label: 'حالت تاریک',
                      trailing: Switch(
                        value: user.isDarkMode,
                        onChanged: (v) =>
                            context.read<UserProvider>().toggleDarkMode(),
                        activeColor: AppColors.primary,
                      ),
                    ),
                    _SettingRow(
                      icon: Icons.notifications_rounded,
                      label: 'یادآور روزانه',
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/settings'),
                    ),
                    _SettingRow(
                      icon: Icons.info_outline_rounded,
                      label: 'دربارهٔ POUYANLY',
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/about'),
                    ),
                    _SettingRow(
                      icon: Icons.map_rounded,
                      label: 'انجام دوباره آزمون سطح',
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/placement-test'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                PButton(
                  label: 'بازنشانی پیشرفت',
                  outlined: true,
                  color: AppColors.error,
                  onPressed: () => _showResetDialog(context),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'بازنشانی پیشرفت؟',
            style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'تمام پیشرفت شما حذف خواهد شد. این عمل قابل بازگشت نیست.',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('لغو',
                  style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await context.read<UserProvider>().reset();
                if (context.mounted) context.go('/welcome');
              },
              child: const Text('بازنشانی',
                  style: TextStyle(
                      fontFamily: 'Vazirmatn', color: AppColors.error)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  const _StatBox(this.value, this.label, this.emoji);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.dividerLight),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 11,
                color: AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.dividerLight),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  const _InfoRow(this.label, this.value, this.emoji);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  const _ScoreRow(this.label, this.score, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 8,
                backgroundColor: AppColors.dividerLight,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$score%',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 14),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
