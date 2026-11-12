import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/persian_digits.dart';
import '../../../core/widgets/xp_bar.dart';
import '../../../core/widgets/animated_game_icons.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/providers/user_provider.dart';
import '../../learning_path/screens/learning_path_screen.dart';
import '../../vocabulary/screens/vocabulary_screen.dart';
import '../../gamification/screens/rewards_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../lessons/models/lesson_data.dart';
import '../../../core/widgets/liquid_glass.dart';
import '../../../core/widgets/user_required_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const LearningPathScreen(),
      _HomePage(onReviewTap: () => setState(() => _tab = 2)),
      const VocabularyScreen(),
      const RewardsScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _tabs),
      bottomNavigationBar: LiquidGlassNavigationBar(
        selectedIndex: _tab,
        onTap: (index) => setState(() => _tab = index),
      ),
    );
  }
}

// ── Home Tab ────────────────────────────────────────────────────────────────

class _HomePage extends StatelessWidget {
  final VoidCallback onReviewTap;
  const _HomePage({required this.onReviewTap});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;
    if (user == null) {
      return UserRequiredState(
        title: 'حساب کاربری پیدا نشد',
        message: 'برای نمایش داشبورد، ابتدا وارد مسیر شروع و ساخت حساب شو.',
        actionLabel: 'رفتن به شروع',
        onPressed: () => context.go('/welcome'),
      );
    }

    final nextLesson = _getNextLesson(user);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    'assets/images/app_icon.jpg',
                    width: 26,
                    height: 26,
                    fit: BoxFit.cover,
                  ),
                ),
                const Text('POUYANLY',
                    style: TextStyle(
                        fontFamily: 'Vazirmatn', fontSize: 18, fontWeight: FontWeight.w800)),
                const Spacer(),
                _StatChip(icon: const AnimatedFlameIcon(size: 19), value: toPersianDigits(user.streak)),
                const SizedBox(width: 8),
                _StatChip(icon: const AnimatedCoinIcon(size: 19), value: toPersianDigits(user.coins)),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── XP Bar ──
                XPBar(
                  level: user.level,
                  xp: user.xp,
                  progress: user.levelProgress,
                ),
                const SizedBox(height: 20),

                // ── Daily Goal Card ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'هدف امروز',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${user.dailyStudyTime?.farsiLabel ?? '۱۰ دقیقه در روز'} • ${toPersianDigits(userProvider.dailyXpEarned)}/۵۰ XP',
                        style: const TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: LinearProgressIndicator(
                          value: (userProvider.dailyProgressPercent / 100),
                          minHeight: 8,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Next Lesson Card ──
                if (nextLesson != null) ...[
                  const Text(
                    'درس بعدی',
                    style: TextStyle(
                        fontFamily: 'Vazirmatn', fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  _LessonCard(lesson: nextLesson),
                  const SizedBox(height: 20),
                ],

                // ── Listening practice ──
                InkWell(
                  onTap: () => context.push('/listening'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.headphones_rounded, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('آزمایشگاه شنیداری', style: TextStyle(
                                fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
                              Text('گوش کن، مفهوم را بفهم و پاسخ بده',
                                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Tutor entry ──
                InkWell(
                  onTap: () => context.push('/tutor'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.auto_awesome_rounded, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('معلم زبان POUYANLY',
                                  style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
                              Text('تمرین کن و بازخورد بگیر • نسخهٔ آزمایشی',
                                  style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Community preview ──
                InkWell(
                  onTap: () => context.push('/community'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.groups_rounded, color: Colors.white),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('جامعهٔ POUYANLY',
                                  style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
                              Text('پیش‌نمایش بخش اجتماعی و اصول ایمنی',
                                  style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Quick Review Card ──
                _QuickReviewCard(
                  completedCount: user.completedLessonIds.length,
                  onTap: onReviewTap,
                ),
                const SizedBox(height: 20),

                // ── Stats Row ──
                Row(
                  children: [
                    _MiniStat(toPersianDigits(user.streak), 'Streak', const AnimatedFlameIcon(size: 22)),
                    const SizedBox(width: 12),
                    _MiniStat(toPersianDigits(user.completedLessonIds.length), 'درس', const AnimatedSymbolIcon(symbol: '✅', size: 22)),
                    const SizedBox(width: 12),
                    _MiniStat(toPersianDigits(user.xp), 'XP', const AnimatedSymbolIcon(symbol: '⭐', size: 22)),
                  ],
                ),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Lesson? _getNextLesson(UserModel user) {
    final units = CourseData.getUnitsForLevel(user.cefrLevel.label);
    for (final unit in units) {
      for (final lesson in unit.lessons) {
        if (!user.completedLessonIds.contains(lesson.id)) return lesson;
      }
    }
    // If all done for current level, try A2
    for (final unit in CourseData.a2Units) {
      for (final lesson in unit.lessons) {
        if (!user.completedLessonIds.contains(lesson.id)) return lesson;
      }
    }
    return null;
  }
}

class _StatChip extends StatelessWidget {
  final Widget icon;
  final String value;
  const _StatChip({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 6),
          Text(value, style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 13,
            fontWeight: FontWeight.w700,
          )),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final Lesson lesson;
  const _LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/lesson/${lesson.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: AnimatedSymbolIcon(symbol: '📚', size: 30, color: Colors.white),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.titleFarsi,
                    style: const TextStyle(
                        fontFamily: 'Vazirmatn', fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '${toPersianDigits(lesson.vocabulary.length)} لغت • ${toPersianDigits(lesson.exercises.length)} تمرین',
                    style: TextStyle(
                        fontFamily: 'Vazirmatn', fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.xpColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+${toPersianDigits(lesson.xpReward)} XP',
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickReviewCard extends StatelessWidget {
  final int completedCount;
  final VoidCallback onTap;
  const _QuickReviewCard({required this.completedCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.successGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const AnimatedSymbolIcon(symbol: '🔁', size: 30, color: Colors.white),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'مرور سریع',
                  style: TextStyle(
                      fontFamily: 'Vazirmatn', fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                Text(
                  completedCount > 0 ? 'کلمات قدیمی را مرور کنید' : 'پس از یادگیری اول فعال می‌شود',
                  style: const TextStyle(
                      fontFamily: 'Vazirmatn', fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          if (completedCount > 0)
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'شروع',
                  style: TextStyle(
                      fontFamily: 'Vazirmatn', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.secondary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Widget icon;
  const _MiniStat(this.value, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(
              fontFamily: 'Vazirmatn', fontSize: 16,
              fontWeight: FontWeight.w700, color: AppColors.primary)),
            Text(label, style: TextStyle(
              fontFamily: 'Vazirmatn', fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
