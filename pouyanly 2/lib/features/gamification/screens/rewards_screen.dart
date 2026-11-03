import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(
        slivers: [
          // ── App Bar with Stats ──
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _TopStat('${user.xp}', 'XP', '⭐'),
                    _TopStat('${user.coins}', 'سکه', '🪙'),
                    _TopStat('${user.streak}', 'Streak', '🔥'),
                    _TopStat('${user.longestStreak}', 'رکورد', '🏆'),
                  ],
                ),
              ),
            ),
            title: const Text('جوایز',
                style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Daily Missions ──
                _SectionTitle('ماموریت‌های امروز'),
                const SizedBox(height: 10),
                _MissionCard(
                  title: 'تکمیل یک درس',
                  emoji: '📚',
                  current: user.completedLessonIds.isNotEmpty ? 1 : 0,
                  total: 1,
                  reward: 20,
                ),
                _MissionCard(
                  title: 'مرور ۵ کلمه',
                  emoji: '🔁',
                  current: 0,
                  total: 5,
                  reward: 15,
                ),
                _MissionCard(
                  title: 'ثبت Streak امروز',
                  emoji: '🔥',
                  current: user.streak > 0 ? 1 : 0,
                  total: 1,
                  reward: 10,
                ),
                const SizedBox(height: 24),

                // ── Achievements ──
                _SectionTitle('دستاوردها'),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                  children: [
                    _AchievementBadge('🌱', 'اول قدم', 'اولین درس', user.completedLessonIds.isNotEmpty),
                    _AchievementBadge('🔥', 'آتش Streak', '۳ روز پیاپی', user.streak >= 3),
                    _AchievementBadge('📚', 'کتابخوان', '۵ درس', user.completedLessonIds.length >= 5),
                    _AchievementBadge('⭐', 'ستاره', '۱۰۰ XP', user.xp >= 100),
                    _AchievementBadge('💪', 'پشتکار', '۷ روز پیاپی', user.streak >= 7),
                    _AchievementBadge('🏆', 'قهرمان', '۱۰۰۰ XP', user.xp >= 1000),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Streak Calendar ──
                _SectionTitle('تقویم هفتگی'),
                const SizedBox(height: 10),
                _StreakCalendar(streak: user.streak),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopStat extends StatelessWidget {
  final String value;
  final String label;
  final String emoji;
  const _TopStat(this.value, this.label, this.emoji);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontFamily: 'Vazirmatn', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
        Text(label,
            style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: Colors.white70)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            fontFamily: 'Vazirmatn', fontSize: 16, fontWeight: FontWeight.w700));
  }
}

class _MissionCard extends StatelessWidget {
  final String title;
  final String emoji;
  final int current;
  final int total;
  final int reward;

  const _MissionCard({
    required this.title,
    required this.emoji,
    required this.current,
    required this.total,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    final done = current >= total;
    final progress = total > 0 ? current / total : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: done ? AppColors.success.withOpacity(0.08) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: done ? AppColors.success.withOpacity(0.4) : AppColors.dividerLight,
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontFamily: 'Vazirmatn', fontSize: 14, fontWeight: FontWeight.w600)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.xpColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('+$reward XP',
                          style: const TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: AppColors.dividerLight,
                          valueColor: AlwaysStoppedAnimation(
                              done ? AppColors.success : AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$current/$total',
                        style: const TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 11,
                            color: AppColors.textSecondaryLight)),
                  ],
                ),
              ],
            ),
          ),
          if (done) ...[
            const SizedBox(width: 8),
            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
          ],
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool unlocked;

  const _AchievementBadge(this.emoji, this.title, this.subtitle, this.unlocked);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked
            ? AppColors.primary.withOpacity(0.08)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked ? AppColors.primary.withOpacity(0.3) : AppColors.dividerLight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            unlocked ? emoji : '🔒',
            style: TextStyle(fontSize: unlocked ? 28 : 22),
          ),
          const SizedBox(height: 6),
          Text(title,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: unlocked ? AppColors.primary : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center),
          Text(subtitle,
              style: const TextStyle(
                  fontFamily: 'Vazirmatn', fontSize: 10, color: AppColors.textSecondaryLight),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _StreakCalendar extends StatelessWidget {
  final int streak;
  const _StreakCalendar({required this.streak});

  @override
  Widget build(BuildContext context) {
    final days = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];
    final today = DateTime.now().weekday % 7; // 0=Sun … 6=Sat

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (i) {
          final isToday = i == today;
          final inStreak = i <= today && i >= (today - streak + 1).clamp(0, 6);
          return Column(
            children: [
              Text(days[i],
                  style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 11,
                      color: isToday ? AppColors.primary : AppColors.textSecondaryLight)),
              const SizedBox(height: 6),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: inStreak
                      ? AppColors.streakColor.withOpacity(0.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: isToday ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    inStreak ? '🔥' : '○',
                    style: TextStyle(fontSize: inStreak ? 18 : 14),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
