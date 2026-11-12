import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/persian_digits.dart';
import '../../../core/widgets/animated_game_icons.dart';
import '../../../shared/providers/user_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) return const SizedBox.shrink();
    final missionProgress = context.watch<UserProvider>().dailyMissionProgress;
    final claimedMissions = context.watch<UserProvider>().claimedDailyMissions;
    final weeklyProgress = context.watch<UserProvider>().weeklyMissionProgress;
    final claimedWeekly = context.watch<UserProvider>().claimedWeeklyMissions;

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
                    _TopStat(toPersianDigits(user.xp), 'XP', '⭐'),
                    _TopStat(toPersianDigits(user.coins), 'سکه', '🪙'),
                    _TopStat(toPersianDigits(user.streak), 'Streak', '🔥'),
                    _TopStat(toPersianDigits(user.longestStreak), 'رکورد', '🏆'),
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
                // ── Level and avatar ──
                _SectionTitle('سطح و آواتار'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.dividerLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(user.avatarEmoji, style: const TextStyle(fontSize: 34)),
                        const SizedBox(width: 12),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('سطح ${toPersianDigits(user.level)}', style: const TextStyle(
                              fontFamily: 'Vazirmatn', fontSize: 18, fontWeight: FontWeight.w800)),
                            Text('${toPersianDigits(user.xpInCurrentLevel)} از ۵۰۰ XP تا سطح بعدی',
                              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 11,
                                color: AppColors.textSecondaryLight)),
                          ],
                        )),
                      ]),
                      const SizedBox(height: 10),
                      ClipRRect(borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(value: user.levelProgress, minHeight: 9)),
                      const SizedBox(height: 14),
                      const Text('انتخاب آواتار', style: TextStyle(
                        fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, runSpacing: 6,
                        children: ['🦊', '🐼', '🐯', '🐸', '🐧', '🦉', '🐙', '🐨']
                          .map((emoji) {
                            final unlocked = user.unlockedAvatarEmojis.contains(emoji);
                            final cost = UserProvider.avatarUnlockCosts[emoji] ?? 0;
                            return ChoiceChip(
                              label: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(emoji, style: const TextStyle(fontSize: 16)),
                                if (!unlocked) ...[
                                  const SizedBox(width: 4),
                                  Text(toPersianDigits(cost), style: const TextStyle(fontSize: 11)),
                                  const SizedBox(width: 3),
                                  const AnimatedCoinIcon(size: 14),
                                ],
                              ]),
                              selected: user.avatarEmoji == emoji,
                              onSelected: (_) async {
                                final provider = context.read<UserProvider>();
                                if (unlocked) {
                                  await provider.setAvatarEmoji(emoji);
                                } else {
                                  final success = await provider.unlockAvatarEmoji(emoji);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(success
                                      ? 'آواتار باز شد؛ دوباره انتخابش کن.'
                                      : 'سکهٔ کافی برای بازکردن این آواتار نداری.',
                                      style: const TextStyle(fontFamily: 'Vazirmatn')),
                                  ));
                                }
                              },
                            );
                          }).toList()),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _SectionTitle('لیگ شخصی آفلاین'),
                const SizedBox(height: 8),
                _OfflineLeagueCard(xp: user.xp),
                const SizedBox(height: 24),

                // ── Daily Missions ──
                _SectionTitle('ماموریت‌های امروز'),
                const SizedBox(height: 10),
                _MissionCard(
                  title: 'تکمیل یک درس',
                  emoji: '📚',
                  current: missionProgress['lesson'] ?? 0,
                  total: 1,
                  reward: 20,
                  coinReward: 5,
                  claimed: claimedMissions.contains('lesson'),
                  onClaim: () => _claimMission(context, 'lesson'),
                ),
                _MissionCard(
                  title: 'مرور ۵ کلمه',
                  emoji: '🔁',
                  current: missionProgress['vocabulary'] ?? 0,
                  total: 5,
                  reward: 15,
                  coinReward: 3,
                  claimed: claimedMissions.contains('vocabulary'),
                  onClaim: () => _claimMission(context, 'vocabulary'),
                ),
                _MissionCard(
                  title: 'حفظ روند مطالعهٔ دو روزه',
                  emoji: '🔥',
                  current: missionProgress['streak'] ?? 0,
                  total: 1,
                  reward: 10,
                  coinReward: 2,
                  claimed: claimedMissions.contains('streak'),
                  onClaim: () => _claimMission(context, 'streak'),
                ),
                const SizedBox(height: 24),

                // ── Weekly Missions ──
                _SectionTitle('ماموریت‌های هفتگی'),
                const SizedBox(height: 10),
                _MissionCard(title: 'تکمیل ۳ درس', emoji: '📖',
                  current: weeklyProgress['lessons'] ?? 0, total: 3, reward: 60, coinReward: 15,
                  claimed: claimedWeekly.contains('lessons'),
                  onClaim: () => _claimWeeklyMission(context, 'lessons')),
                _MissionCard(title: 'مرور ۲۰ واژه', emoji: '🧠',
                  current: weeklyProgress['vocabulary'] ?? 0, total: 20, reward: 50, coinReward: 12,
                  claimed: claimedWeekly.contains('vocabulary'),
                  onClaim: () => _claimWeeklyMission(context, 'vocabulary')),
                _MissionCard(title: 'مطالعه در ۴ روز متفاوت', emoji: '📅',
                  current: weeklyProgress['studyDays'] ?? 0, total: 4, reward: 75, coinReward: 20,
                  claimed: claimedWeekly.contains('studyDays'),
                  onClaim: () => _claimWeeklyMission(context, 'studyDays')),
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
        AnimatedSymbolIcon(symbol: emoji, size: 25, color: Colors.white),
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

void _claimWeeklyMission(BuildContext context, String missionId) async {
  final claimed = await context.read<UserProvider>().claimWeeklyMission(missionId);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
    claimed ? 'پاداش هفتگی دریافت شد!' : 'ماموریت هنوز کامل نشده یا قبلاً دریافت شده است.',
    style: const TextStyle(fontFamily: 'Vazirmatn'),
  )));
}

void _claimMission(BuildContext context, String missionId) async {
  final claimed = await context.read<UserProvider>().claimDailyMission(missionId);
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        claimed ? 'جایزه به حساب تو اضافه شد!' : 'این مأموریت هنوز کامل نشده یا جایزه‌اش دریافت شده است.',
        style: const TextStyle(fontFamily: 'Vazirmatn'),
      ),
    ),
  );
}

class _MissionCard extends StatelessWidget {
  final String title;
  final String emoji;
  final int current;
  final int total;
  final int reward;
  final int coinReward;
  final bool claimed;
  final VoidCallback onClaim;

  const _MissionCard({
    required this.title,
    required this.emoji,
    required this.current,
    required this.total,
    required this.reward,
    this.coinReward = 0,
    required this.claimed,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final done = current >= total;
    final progress = total > 0 ? current / total : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: done ? AppColors.success.withValues(alpha: 0.08) : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: done ? AppColors.success.withValues(alpha: 0.4) : AppColors.dividerLight,
        ),
      ),
      child: Row(
        children: [
          AnimatedSymbolIcon(symbol: emoji, size: 31, color: AppColors.primary),
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
                        color: AppColors.xpColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text('+${toPersianDigits(reward)} XP', style: const TextStyle(
                          fontFamily: 'Vazirmatn', fontSize: 11,
                          fontWeight: FontWeight.w700, color: AppColors.warning)),
                        if (coinReward > 0) ...[
                          const SizedBox(width: 5),
                          Text('+${toPersianDigits(coinReward)}', style: const TextStyle(
                            fontFamily: 'Vazirmatn', fontSize: 11,
                            fontWeight: FontWeight.w700, color: AppColors.warning)),
                          const SizedBox(width: 3),
                          const AnimatedCoinIcon(size: 15),
                        ],
                      ]),
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
                    Text('${toPersianDigits(current)}/${toPersianDigits(total)}',
                        style: const TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 11,
                            color: AppColors.textSecondaryLight)),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: claimed
                      ? const Text('جایزه دریافت شد ✓',
                          style: TextStyle(fontFamily: 'Vazirmatn', color: AppColors.success, fontSize: 11))
                      : TextButton(
                          onPressed: done ? onClaim : null,
                          child: Text(done ? 'دریافت جایزه' : 'پس از تکمیل فعال می‌شود',
                              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 11)),
                        ),
                ),
              ],
            ),
          ),
          if (done && !claimed) ...[
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
            ? AppColors.primary.withValues(alpha: 0.08)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked ? AppColors.primary.withValues(alpha: 0.3) : AppColors.dividerLight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSymbolIcon(
            symbol: unlocked ? emoji : '🔒',
            size: unlocked ? 31 : 25,
            color: unlocked ? AppColors.primary : AppColors.textSecondaryLight,
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
                      ? AppColors.streakColor.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: Border.all(
                    color: isToday ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: inStreak
                      ? const AnimatedFlameIcon(size: 22)
                      : const Icon(Icons.circle_outlined, size: 14),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
class _OfflineLeagueCard extends StatelessWidget {
  final int xp;
  const _OfflineLeagueCard({required this.xp});

  @override
  Widget build(BuildContext context) {
    final String tier;
    final int next;
    if (xp < 500) { tier = 'برنز'; next = 500; }
    else if (xp < 1500) { tier = 'نقره‌ای'; next = 1500; }
    else if (xp < 3500) { tier = 'طلایی'; next = 3500; }
    else { tier = 'الماسی'; next = 3500; }
    final progress = xp >= 3500 ? 1.0 : (xp / next).clamp(0.0, 1.0).toDouble();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        const AnimatedSymbolIcon(symbol: '🏅', size: 36, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('لیگ $tier', style: const TextStyle(fontFamily: 'Vazirmatn',
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
            Text(xp >= 3500 ? 'بالاترین لیگ فعلی را باز کردی' : 'برای لیگ بعدی به ${toPersianDigits(next)} XP برس',
              style: const TextStyle(fontFamily: 'Vazirmatn', color: Colors.white70, fontSize: 11)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: progress, backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
          ])),
      ]),
    );
  }
}

