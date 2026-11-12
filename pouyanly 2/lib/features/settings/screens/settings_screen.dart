import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../core/services/learning_reminder_service.dart';
import '../../../core/widgets/liquid_glass.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification settings (stored locally in UI state — would persist with backend)
  bool _notificationsEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);
  final Set<int> _activeDays = {1, 2, 3, 4, 5}; // Mon–Fri

  final List<String> _dayNames = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];
  @override
  void initState() {
    super.initState();
    _notificationsEnabled = context.read<UserProvider>().user?.notificationsEnabled ?? true;
    SharedPreferences.getInstance().then((prefs) {
      if (!mounted) return;
      setState(() {
        _reminderTime = TimeOfDay(
          hour: prefs.getInt('learningReminderHour') ?? 20,
          minute: prefs.getInt('learningReminderMinute') ?? 0,
        );
        _activeDays
          ..clear()
          ..addAll((prefs.getStringList('learningReminderDays') ?? ['1', '2', '3', '4', '5'])
              .map((value) => int.tryParse(value)).whereType<int>());
      });
      if (_notificationsEnabled) {
        LearningReminderService.scheduleWeekly(time: _reminderTime, activeDays: _activeDays);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تنظیمات',
            style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ─── Notifications Section ───
            _SectionHeader(title: 'یادآور روزانه', icon: Icons.notifications_rounded),
            const SizedBox(height: 8),
            _SettingCard(
              children: [
                SwitchListTile(
                  value: _notificationsEnabled,
                  onChanged: (v) async {
                    setState(() => _notificationsEnabled = v);
                    final current = context.read<UserProvider>().user;
                    if (current != null) {
                      await context.read<UserProvider>().updateUser(current.copyWith(notificationsEnabled: v));
                    }
                    await _persistReminderSettings();
                    if (v) {
                      await LearningReminderService.scheduleWeekly(time: _reminderTime, activeDays: _activeDays);
                    } else {
                      await LearningReminderService.cancelAll();
                    }
                  },
                  activeThumbColor: scheme.primary,
                  title: const Text(
                    'فعال‌سازی یادآور',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15),
                  ),
                  subtitle: const Text(
                    'هر روز در زمان مشخص یادآوری می‌شود',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 12),
                  ),
                ),
                if (_notificationsEnabled) ...[
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text(
                      'زمان یادآور',
                      style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatTime(_reminderTime),
                        style: const TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: scheme.primary,
                        ),
                      ),
                    ),
                    onTap: () => _pickTime(context),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'روزهای فعال',
                          style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (i) {
                            final active = _activeDays.contains(i);
                            return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  if (active) {
                                    if (_activeDays.length > 1) _activeDays.remove(i);
                                  } else {
                                    _activeDays.add(i);
                                  }
                                });
                                await _persistReminderSettings();
                                if (_notificationsEnabled) {
                                  try {
                                    await LearningReminderService.scheduleWeekly(time: _reminderTime, activeDays: _activeDays);
                                  } catch (_) {}
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: active ? scheme.primary : Colors.transparent,
                                  border: Border.all(
                                    color: active ? scheme.primary : scheme.outline,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _dayNames[i],
                                    style: TextStyle(
                                      fontFamily: 'Vazirmatn',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: active ? scheme.onPrimary : scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 20),
            _SectionHeader(title: 'ویجت صفحهٔ اصلی اندروید', icon: Icons.widgets_rounded),
            const SizedBox(height: 8),
            _SettingCard(children: [
              ListTile(
                leading: Icon(Icons.auto_graph_rounded, color: scheme.primary),
                title: Text('نمایش پیشرفت روزانه', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 14, fontWeight: FontWeight.w700)),
                subtitle: Text('در صفحهٔ اصلی گوشی، روی فضای خالی چند لحظه نگه دار؛ سپس «ابزارک‌ها» و POUYANLY را انتخاب کن.', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, height: 1.6)),
              ),
            ]),

            const SizedBox(height: 24),

            // ─── Appearance Section ───
            _SectionHeader(title: 'ظاهر برنامه', icon: Icons.palette_rounded),
            const SizedBox(height: 8),
            _SettingCard(
              children: [
                SwitchListTile(
                  value: isDark,
                  onChanged: (_) => context.read<UserProvider>().toggleDarkMode(),
                  activeThumbColor: scheme.primary,
                  title: const Text(
                    'حالت تاریک',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15),
                  ),
                  subtitle: Text(
                    isDark ? 'حالت تاریک فعال است' : 'حالت روشن فعال است',
                    style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12),
                  ),
                  secondary: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ─── Study Settings Section ───
            _SectionHeader(title: 'تنظیمات یادگیری', icon: Icons.school_rounded),
            const SizedBox(height: 8),
            _SettingCard(
              children: [
                ListTile(
                  leading: const Icon(Icons.refresh_rounded, color: scheme.primary),
                  title: const Text(
                    'انجام دوباره آزمون تعیین سطح',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15),
                  ),
                  subtitle: const Text(
                    'سطح فعلی شما به‌روزرسانی خواهد شد',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => _confirmRedoPlacementTest(context),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.tune_rounded, color: scheme.secondary),
                  title: const Text(
                    'ویرایش اهداف یادگیری',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15),
                  ),
                  subtitle: const Text(
                    'هدف و زمان مطالعه روزانه',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_left_rounded),
                  onTap: () => context.go('/onboarding'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ─── About Section ───
            _SectionHeader(title: 'درباره برنامه', icon: Icons.info_rounded),
            const SizedBox(height: 8),
            _SettingCard(
              children: [
                ListTile(
                  leading: Icon(Icons.tag_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: Text(
                    'نسخه برنامه',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15),
                  ),
                  trailing: Text(
                    '۱.۰.۰',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  leading: Icon(Icons.translate_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  title: Text(
                    'زبان رابط',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15),
                  ),
                  trailing: Text(
                    'فارسی',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: scheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.18),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: scheme.onPrimary.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: scheme.onPrimary.withValues(alpha: 0.24)),
                    ),
                    child: Icon(Icons.code_rounded, color: scheme.onPrimary, size: 27),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ساخته‌شده توسط',
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 12,
                            color: scheme.onPrimary.withValues(alpha: 0.78),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'پویان سلجوقی',
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: scheme.onPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'با علاقه به یادگیری و فناوری',
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.auto_awesome_rounded, color: scheme.onPrimary.withValues(alpha: 0.82), size: 22),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ─── Danger Zone ───
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.errorContainer.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: scheme.error.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚠️ منطقه خطر',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: scheme.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showResetDialog(context),
                      icon: const Icon(Icons.delete_forever_rounded, color: scheme.error),
                      label: const Text(
                        'بازنشانی کامل پیشرفت',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          color: scheme.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: scheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _persistReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('learningReminderEnabled', _notificationsEnabled);
    await prefs.setInt('learningReminderHour', _reminderTime.hour);
    await prefs.setInt('learningReminderMinute', _reminderTime.minute);
    await prefs.setStringList(
      'learningReminderDays',
      _activeDays.map((day) => day.toString()).toList(),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (ctx, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
      await _persistReminderSettings();
      if (_notificationsEnabled) {
        try {
          await LearningReminderService.scheduleWeekly(time: picked, activeDays: _activeDays);
        } catch (_) {}
      }
    }
  }

  void _confirmRedoPlacementTest(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'آزمون تعیین سطح مجدد؟',
            style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'سطح فعلی شما با نتیجه آزمون جدید به‌روزرسانی خواهد شد.',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('لغو', style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/placement-test');
              },
              child: const Text(
                'شروع آزمون',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
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
            'بازنشانی کامل؟',
            style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'تمام پیشرفت، XP، Streak، و درس‌های تکمیل‌شده حذف خواهند شد.\n\nاین عمل غیرقابل بازگشت است.',
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('لغو', style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await context.read<UserProvider>().reset();
                if (context.mounted) context.go('/welcome');
              },
              child: const Text(
                'بازنشانی',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SettingCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(18),
      child: Column(children: children),
    );
  }
}
