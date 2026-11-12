import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/persian_digits.dart';
import '../../../core/widgets/animated_game_icons.dart';
import '../../../core/widgets/p_button.dart';
import '../../../core/widgets/user_required_state.dart';
import '../../../shared/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const int _avatarShopXpThreshold = 1000;
  bool _promptScheduled = false;

  @override
  void initState() {
    super.initState();
    // Keep this screen safe when reached directly, outside the splash route.
    context.read<UserProvider>().init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybePromptAvatarShop();
  }

  void _maybePromptAvatarShop() {
    final user = context.read<UserProvider>().user;
    if (_promptScheduled || user == null || user.xp < _avatarShopXpThreshold || user.avatarShopPromptShown) return;
    _promptScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<UserProvider>().markAvatarShopPromptShown();
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (dialogContext) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('وقتشه آواتارت رو ارتقا بدی!', style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w800)),
            content: const Text('امتیاز XP خوبی جمع کردی. به فروشگاه پروفایل سر بزن و یک آواتار تازه انتخاب کن.', style: TextStyle(fontFamily: 'Vazirmatn')),
            actions: [
              TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('بعداً')),
              FilledButton(onPressed: () { Navigator.pop(dialogContext); _showAvatarShop(); }, child: const Text('فروشگاه آواتار')),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _showAvatarShop() async {
    final provider = context.read<UserProvider>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: Consumer<UserProvider>(builder: (context, currentProvider, _) {
          final user = currentProvider.user;
          if (user == null) {
      return UserRequiredState(
        title: 'پروفایل هنوز آماده نیست',
        message: 'اطلاعات حساب بارگذاری نشده است. برای ورود دوباره به مسیر شروع برنامه برو.',
        actionLabel: 'رفتن به شروع',
        onPressed: () => context.go('/welcome'),
      );
    }
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('فروشگاه آواتار', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('سکهٔ در دسترس: ${toPersianDigits(user.coins)}', style: TextStyle(fontFamily: 'Vazirmatn', color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                Wrap(spacing: 10, runSpacing: 10, children: ['🦊', '🐼', '🐯', '🐸', '🐧', '🦉', '🐙', '🐨'].map((emoji) {
                  final unlocked = user.unlockedAvatarEmojis.contains(emoji);
                  final cost = UserProvider.avatarUnlockCosts[emoji] ?? 0;
                  final selected = user.avatarEmoji == emoji;
                  return InkWell(
                    onTap: () async {
                      if (unlocked) {
                        await provider.setAvatarEmoji(emoji);
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                        return;
                      }
                      final success = await provider.unlockAvatarEmoji(emoji);
                      if (success) await provider.setAvatarEmoji(emoji);
                      if (!sheetContext.mounted) return;
                      if (success) {
                        Navigator.pop(sheetContext);
                      } else {
                        ScaffoldMessenger.of(sheetContext).showSnackBar(const SnackBar(content: Text('سکهٔ کافی نداری.')));
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(width: 76, height: 82, decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withValues(alpha: .12) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant, width: selected ? 2 : 1),
                    ), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(emoji, style: const TextStyle(fontSize: 30)),
                      const SizedBox(height: 3),
                      if (!unlocked) Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(toPersianDigits(cost), style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 10)), const SizedBox(width: 3), const AnimatedCoinIcon(size: 12)])
                      else Text(selected ? 'انتخاب‌شده' : 'رایگان', style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 9)),
                    ])),
                  );
                }).toList()),
              ]),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final user = provider.user;
    if (user == null) {
      final theme = Theme.of(context);
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  provider.isInitialized
                      ? Icons.person_off_outlined
                      : Icons.person_outline_rounded,
                  size: 54,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  provider.isInitialized
                      ? 'هنوز حسابی برای نمایش وجود ندارد'
                      : 'در حال بارگذاری پروفایل…',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  provider.isInitialized
                      ? 'برای ساخت حساب و شروع یادگیری، به صفحهٔ شروع برو.'
                      : 'اطلاعات حساب در حال آماده‌سازی است.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                if (!provider.isInitialized)
                  const CircularProgressIndicator()
                else
                  FilledButton(
                    onPressed: () => context.go('/welcome'),
                    child: const Text('رفتن به صفحهٔ شروع'),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    _maybePromptAvatarShop();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                child: Stack(children: [
                  Positioned.fill(child: Center(child: Opacity(opacity: .16, child: FittedBox(fit: BoxFit.contain, child: Text(user.avatarEmoji, style: const TextStyle(fontSize: 190)))))),
                  SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: _showAvatarShop,
                        customBorder: const CircleBorder(),
                        child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: user.xp >= _avatarShopXpThreshold ? AppColors.error : Colors.white, width: user.xp >= _avatarShopXpThreshold ? 5 : 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(user.avatarEmoji, style: const TextStyle(fontSize: 48)),
                        ),
                      )),
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
                          'ردهٔ مهارت: ${_skillBandLabel(user.cefrLevel)}',
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
                ]),
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
                    _StatBox(toPersianDigits(user.xp), 'امتیاز XP', '⭐'),
                    const SizedBox(width: 10),
                    _StatBox(toPersianDigits(user.streak), 'روز پیاپی', '🔥'),
                    const SizedBox(width: 10),
                    _StatBox(toPersianDigits(user.completedLessonIds.length), 'درس', '✅'),
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
                    _InfoRow('ردهٔ مهارت', _skillBandLabel(user.cefrLevel), '📊'),
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
                        activeThumbColor: Theme.of(context).colorScheme.primary,
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

  String _skillBandLabel(dynamic level) {
    final name = level.name.toString();
    if (name == 'a1' || name == 'a2') return 'مبتدی';
    if (name == 'b1') return 'متوسط';
    if (name == 'b2') return 'متوسط رو به بالا';
    if (name == 'c1' || name == 'c2') return 'پیشرفته';
    return 'هنوز ارزیابی نشده';
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
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            AnimatedSymbolIcon(symbol: emoji, size: 25, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
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
          style: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Theme.of(context).dividerColor),
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
          AnimatedSymbolIcon(symbol: emoji, size: 21, color: Theme.of(context).colorScheme.primary),
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
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
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
                backgroundColor: Theme.of(context).colorScheme.outlineVariant,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            toPersianDigits('$score٪'),
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
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
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
