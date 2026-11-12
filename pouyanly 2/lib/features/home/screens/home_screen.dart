import 'package:flutter/material.dart';
import '../../../core/widgets/pouyanly_icon.dart';
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
    final provider = context.watch<UserProvider>();
    final user = provider.user;
    if (user == null) {
      return UserRequiredState(
        title: 'حساب کاربری پیدا نشد',
        message: 'برای نمایش داشبورد، ابتدا وارد مسیر شروع و ساخت حساب شو.',
        actionLabel: 'رفتن به شروع',
        onPressed: () => context.go('/welcome'),
      );
    }
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final nextLesson = _getNextLesson(user);
    final firstName = user.firstName?.trim().isNotEmpty == true
        ? user.firstName!.trim()
        : (user.name?.trim().split(' ').first ?? 'زبان‌آموز');
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueReviews = user.vocabularyReviewDueDates.values.where((value) {
      final due = DateTime.tryParse(value);
      return due == null || !DateTime(due.year, due.month, due.day).isAfter(today);
    }).length;
    const targetXp = 50;
    final progress = (provider.dailyXpEarned / targetXp).clamp(0.0, 1.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(
        key: const PageStorageKey<String>('pouyanly-dashboard-scroll'),
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            titleSpacing: 20,
            title: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset('assets/images/app_icon.jpg', width: 34, height: 34, fit: BoxFit.cover),
              ),
              const SizedBox(width: 10),
              const Text('POUYANLY', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 17, fontWeight: FontWeight.w900)),
              const Spacer(),
              _StatChip(icon: const AnimatedFlameIcon(size: 18), value: toPersianDigits(user.streak)),
              const SizedBox(width: 7),
              _StatChip(icon: const AnimatedCoinIcon(size: 18), value: toPersianDigits(user.coins)),
            ]),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Text('سلام ' + firstName + ' 👋', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text('آماده‌ای امروز یک قدم جلوتر بروی؟', style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [scheme.primary, Color.lerp(scheme.primary, scheme.secondary, .42)!]),
                  borderRadius: BorderRadius.circular(23),
                  boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: .2), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const PouyanlyIcon(type: PouyanlyIconType.target, color: Colors.white, size: 23),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('هدف روزانه', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontWeight: FontWeight.w700))),
                    Text(toPersianDigits(provider.dailyXpEarned) + ' / ' + toPersianDigits(targetXp) + ' XP', style: const TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                  ]),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(value: progress, minHeight: 9, backgroundColor: Colors.white.withValues(alpha: .24), valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)),
                  ),
                  const SizedBox(height: 9),
                  Text(progress >= 1 ? 'آفرین! هدف XP امروز را تکمیل کردی.' : 'با هر درس و تمرین، به هدف امروز نزدیک‌تر می‌شوی.', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, color: Colors.white.withValues(alpha: .92))),
                ]),
              ),
              const SizedBox(height: 18),
              Row(children: [
                Expanded(child: _MiniStat(toPersianDigits(user.xp), 'مجموع XP', const PouyanlyIcon(type: PouyanlyIconType.trophy, size: 22))),
                const SizedBox(width: 9),
                Expanded(child: _MiniStat(toPersianDigits(user.completedLessonIds.length), 'درس تکمیل‌شده', const PouyanlyIcon(type: PouyanlyIconType.completed, size: 22))),
                const SizedBox(width: 9),
                Expanded(child: _MiniStat(toPersianDigits(user.longestStreak), 'بهترین زنجیره', const PouyanlyIcon(type: PouyanlyIconType.streak, size: 22))),
              ]),
              const SizedBox(height: 25),
              Text('ادامهٔ یادگیری', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('از همان‌جایی که باید، ادامه بده', style: theme.textTheme.bodySmall),
              const SizedBox(height: 11),
              if (nextLesson != null)
                _LessonCard(lesson: nextLesson)
              else
                _QuickReviewCard(completedCount: user.completedLessonIds.length, onTap: onReviewTap),
              const SizedBox(height: 25),
              Text('تمرین‌های سریع', style: theme.textTheme.titleLarge),
              const SizedBox(height: 11),
              _DashboardAction(
                icon: PouyanlyIconType.review,
                title: 'مرور واژگان',
                description: dueReviews == 0 ? 'واژهٔ سررسیدشده‌ای برای مرور نداری' : toPersianDigits(dueReviews) + ' واژه آمادهٔ مرور است',
                action: 'مرور',
                onTap: onReviewTap,
              ),
              const SizedBox(height: 9),
              _DashboardAction(icon: PouyanlyIconType.listening, title: 'آزمایشگاه شنیداری', description: 'درک مطلب شنیداری را تمرین کن', action: 'شروع', onTap: () => context.push('/listening')),
              const SizedBox(height: 9),
              _DashboardAction(icon: PouyanlyIconType.brain, title: 'معلم زبان POUYANLY', description: 'پرسش‌هایت را دربارهٔ زبان بررسی کن', action: 'ورود', onTap: () => context.push('/tutor')),
              const SizedBox(height: 24),
              Text('سطح فعلی تو', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(user.cefrLevel.farsiDescription, style: theme.textTheme.bodySmall),
              const SizedBox(height: 10),
              XPBar(level: user.level, xp: user.xp, progress: user.levelProgress),
              const SizedBox(height: 20),
            ])),
          ),
        ],
      ),
    );
  }

  Lesson? _getNextLesson(UserModel user) {
    final completed = user.completedLessonIds.toSet();
    for (final unit in CourseData.getUnitsForLevel(user.cefrLevel.label)) {
      for (final lesson in unit.lessons) {
        if (!completed.contains(lesson.id)) return lesson;
      }
    }
    return null;
  }
}

class _DashboardAction extends StatelessWidget {
  final PouyanlyIconType icon;
  final String title, description, action;
  final VoidCallback onTap;
  const _DashboardAction({required this.icon, required this.title, required this.description, required this.action, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minHeight: 76),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: scheme.outlineVariant.withValues(alpha: .65))),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(14)),
              child: Center(child: PouyanlyIcon(type: icon, color: scheme.onPrimaryContainer, size: 22)),
            ),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 2),
              Text(description, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
            ])),
            const SizedBox(width: 5),
            Text(action, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.primary, fontWeight: FontWeight.w800)),
            Icon(Icons.chevron_left_rounded, size: 19, color: scheme.onSurfaceVariant),
          ]),
        ),
      ),
    );
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
    final scheme = Theme.of(context).colorScheme;
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
                gradient: LinearGradient(colors: [scheme.primary, scheme.secondary]),
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
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+${toPersianDigits(lesson.xpReward)} XP',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: scheme.onPrimaryContainer,
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
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          PouyanlyIcon(type: PouyanlyIconType.review, size: 30, color: Theme.of(context).colorScheme.onTertiaryContainer),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرور سریع',
                  style: TextStyle(
                      fontFamily: 'Vazirmatn', fontSize: 15, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onTertiaryContainer),
                ),
                Text(
                  completedCount > 0 ? 'کلمات قدیمی را مرور کنید' : 'پس از یادگیری اول فعال می‌شود',
                  style: TextStyle(
                      fontFamily: 'Vazirmatn', fontSize: 12, color: Theme.of(context).colorScheme.onTertiaryContainer.withValues(alpha: .78)),
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
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'شروع',
                  style: TextStyle(
                      fontFamily: 'Vazirmatn', fontSize: 12, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface),
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
    final scheme = Theme.of(context).colorScheme;
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
              fontWeight: FontWeight.w700, color: scheme.primary)),
            Text(label, style: TextStyle(
              fontFamily: 'Vazirmatn', fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
