import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
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
  final List<String> _dayNamesLong = [
    'شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه'
  ];

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
    final isDark = user?.isDarkMode == true;

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
                    if (v) {
                      await LearningReminderService.scheduleWeekly(time: _reminderTime, activeDays: _activeDays);
                    } else {
                      await LearningReminderService.cancelAll();
                    }
                  },
                  activeColor: AppColors.primary,
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
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatTime(_reminderTime),
                        style: const TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
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
                                  color: active ? AppColors.primary : Colors.transparent,
                                  border: Border.all(
                                    color: active ? AppColors.primary : AppColors.dividerLight,
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
                                      color: active ? Colors.white : AppColors.textSecondaryLight,
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
            _SettingCard(children: const [
              ListTile(
                leading: Icon(Icons.auto_graph_rounded, color: AppColors.primary),
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
                  activeColor: AppColors.primary,
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
                    color: AppColors.primary,
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
                  leading: const Icon(Icons.refresh_rounded, color: AppColors.primary),
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
                  leading: const Icon(Icons.tune_rounded, color: AppColors.secondary),
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
                const ListTile(
                  leading: Icon(Icons.tag_rounded, color: AppColors.textSecondaryLight),
                  title: Text(
                    'نسخه برنامه',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15),
                  ),
                  trailing: Text(
                    '۱.۰.۰',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                const ListTile(
                  leading: Icon(Icons.translate_rounded, color: AppColors.textSecondaryLight),
                  title: Text(
                    'زبان رابط',
                    style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15),
                  ),
                  trailing: Text(
                    'فارسی',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.18),
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
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.24)),
                    ),
                    child: const Icon(Icons.code_rounded, color: Colors.white, size: 27),
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
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'پویان سلجوقی',
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
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
                  const Icon(Icons.auto_awesome_rounded, color: Colors.white70, size: 22),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ─── Danger Zone ───
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.error.withOpacity(0.2)),
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
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showResetDialog(context),
                      icon: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
                      label: const Text(
                        'بازنشانی کامل پیشرفت',
                        style: TextStyle(
                          fontFamily: 'Vazirmatn',
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.error),
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
                  color: AppColors.primary,
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
                  color: AppColors.error,
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
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondaryLight,
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
