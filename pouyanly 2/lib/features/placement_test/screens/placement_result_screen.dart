import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/p_button.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/providers/user_provider.dart';

class PlacementResultScreen extends StatelessWidget {
  const PlacementResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final cefrLevel = user.cefrLevel;
    final color = AppColors.cefrColor(cefrLevel.label);

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // ── CEFR Badge ──
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cefrLevel.label,
                          style: const TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'سطح شما',
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'نتیجه آزمون شما',
                  style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  _skillBandLabel(cefrLevel),
                  style: TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 15,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Skill Bars ──
                if (user.skillScores.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.dividerLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'مهارت‌های شما',
                          style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        if (user.skillScores.containsKey('vocabulary'))
                          _SkillBar('لغت', user.skillScores['vocabulary']!, AppColors.primary),
                        if (user.skillScores.containsKey('grammar'))
                          _SkillBar('گرامر', user.skillScores['grammar']!, AppColors.secondary),
                        if (user.skillScores.containsKey('reading'))
                          _SkillBar('خواندن', user.skillScores['reading']!, AppColors.accent),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Personal focus ──
                if (user.skillScores.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.dividerLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'اولویت پیشنهادی برای شما',
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getSkillRecommendation(user.skillScores),
                          style: const TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 12,
                            height: 1.8,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        if (user.dailyStudyTime != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'برنامهٔ پیشنهادی: روزانه ${user.dailyStudyTime!.minutes} دقیقه تمرین',
                            style: const TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // ── Recommended Path ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary.withOpacity(0.08), AppColors.secondary.withOpacity(0.08)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🗺️ مسیر یادگیری پیشنهادی',
                        style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getRecommendation(cefrLevel),
                        style: const TextStyle(
                          fontFamily: 'Vazirmatn',
                          fontSize: 13,
                          color: AppColors.textSecondaryLight,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                PButton(
                  label: 'شروع یادگیری',
                  onPressed: () => context.go('/home'),
                  icon: Icons.school_rounded,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _skillBandLabel(CefrLevel level) {
    switch (level) {
      case CefrLevel.a1:
      case CefrLevel.a2: return 'مبتدی';
      case CefrLevel.b1: return 'متوسط';
      case CefrLevel.b2: return 'متوسط رو به بالا';
      case CefrLevel.c1:
      case CefrLevel.c2: return 'پیشرفته';
      case CefrLevel.unknown: return 'هنوز ارزیابی نشده';
    }
  }

  String _getSkillRecommendation(Map<String, int> scores) {
    const labels = {
      'vocabulary': 'واژگان',
      'grammar': 'گرامر',
      'reading': 'درک مطلب',
    };
    final weakest = scores.entries.reduce(
      (a, b) => a.value <= b.value ? a : b,
    );
    final label = labels[weakest.key] ?? weakest.key;
    if (weakest.value >= 85) {
      return 'عملکرد مهارت‌های سنجیده‌شده متعادل است. برای تشخیص دقیق‌تر، تمرین شنیداری و مکالمه هم لازم است.';
    }
    return 'فعلاً بهتر است روی $label تمرکز کنی. تمرین‌های کوتاه و مرور منظم این مهارت را تقویت می‌کند.';
  }

  String _getRecommendation(CefrLevel level) {
    switch (level) {
      case CefrLevel.a1:
        return 'از پایه شروع می‌کنید. واحدهای احوال‌پرسی، اعداد، و خانواده اول اهمیت دارند. روزی ۵ کلمه یاد بگیرید.';
      case CefrLevel.a2:
        return 'پایه‌های خوبی دارید. زندگی روزمره، خرید، و مکالمات ساده را تقویت کنید.';
      case CefrLevel.b1:
        return 'در محدودهٔ متوسط هستید. روی گرامر پیشرفته و واژگان تخصصی تمرکز کنید.';
      case CefrLevel.b2:
        return 'در محدودهٔ متوسط رو به بالا هستید؛ روی استدلال‌نویسی، زبان آکادمیک و متون پیچیده تمرکز کنید.';
      case CefrLevel.c1:
        return 'در محدودهٔ پیشرفته هستید؛ روی بلاغت، تحلیل پژوهش، زبان حرفه‌ای و ظرافت‌های سبکی کار کنید.';
      case CefrLevel.c2:
        return 'در محدودهٔ پیشرفته هستید؛ روی دقت معنایی، گفتمان پیچیده و انتخاب سبک تمرکز کنید.';
      case CefrLevel.unknown:
        return 'برای تعیین سطح دقیق‌تر، آزمون را کامل کن.';
    }
  }
}

class _SkillBar extends StatelessWidget {
  final String label;
  final int score;
  final Color color;
  const _SkillBar(this.label, this.score, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13)),
              Text('$score%',
                  style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: score / 100),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            builder: (ctx, val, _) => ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: val,
                minHeight: 10,
                backgroundColor: AppColors.dividerLight,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
