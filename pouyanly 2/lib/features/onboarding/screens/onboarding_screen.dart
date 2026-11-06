import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/p_button.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/providers/user_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _page = 0;
  final _nameController = TextEditingController();

  LearningGoal? _goal;
  EngLevel? _level;
  StudyTime? _time;
  StudyPeriod? _period;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 3) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
      setState(() => _page++);
    } else {
      _submit();
    }
  }

  Future<void> _submit() async {
    if (_goal == null || _level == null || _time == null || _period == null || _nameController.text.trim().isEmpty) return;
    await context.read<UserProvider>().setOnboardingData(
          goal: _goal!,
          level: _level!,
          time: _time!,
          period: _period!,
          name: _nameController.text.trim(),
        );
    if (mounted) context.go('/placement-test');
  }

  bool get _canNext {
    switch (_page) {
      case 0: return _goal != null && _nameController.text.trim().isNotEmpty;
      case 1: return _level != null;
      case 2: return _time != null;
      case 3: return _period != null;
      default: return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: List.generate(4, (i) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: i <= _page ? AppColors.primary : AppColors.dividerLight,
                    ),
                  ),
                )),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'مرحله ${_page + 1} از ۴',
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 12,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ),

            // ── Pages ──
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _GoalPage(selected: _goal, onSelect: (g) => setState(() => _goal = g), nameController: _nameController),
                  _LevelPage(selected: _level, onSelect: (l) => setState(() => _level = l)),
                  _TimePage(selected: _time, onSelect: (t) => setState(() => _time = t)),
                  _PeriodPage(selected: _period, onSelect: (p) => setState(() => _period = p)),
                ],
              ),
            ),

            // ── Next Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: PButton(
                label: _page == 3 ? 'شروع آزمون تعیین سطح' : 'بعدی',
                onPressed: _canNext ? _next : null,
                icon: _page == 3 ? Icons.play_arrow_rounded : Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Goal Page ──────────────────────────────────────────────────────────────

class _GoalPage extends StatelessWidget {
  final LearningGoal? selected;
  final ValueChanged<LearningGoal> onSelect;
  final TextEditingController nameController;
  const _GoalPage({required this.selected, required this.onSelect, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('هدف شما از یادگیری چیست؟',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('بهترین مسیر یادگیری را برای شما تنظیم می‌کنیم',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, color: AppColors.textSecondaryLight)),
          const SizedBox(height: 14),
          TextField(
            controller: nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'اسم دلخواه شما (اجباری)',
              hintText: 'مثلاً Pouyan یا هر نامی که دوست داری',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            onChanged: (_) {},
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              children: LearningGoal.values.map((g) => _ChoiceCard(
                label: g.farsiLabel,
                selected: selected == g,
                onTap: () => onSelect(g),
                emoji: _goalEmoji(g),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _goalEmoji(LearningGoal g) {
    switch (g) {
      case LearningGoal.travel:        return '✈️';
      case LearningGoal.work:          return '💼';
      case LearningGoal.study:         return '🎓';
      case LearningGoal.immigration:   return '🌍';
      case LearningGoal.entertainment: return '🎬';
      case LearningGoal.exam:          return '📝';
      case LearningGoal.general:       return '📚';
    }
  }
}

// ── Level Page ──────────────────────────────────────────────────────────────

class _LevelPage extends StatelessWidget {
  final EngLevel? selected;
  final ValueChanged<EngLevel> onSelect;
  const _LevelPage({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('سطح فعلی انگلیسی شما چیست؟',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('نگران نباشید — آزمون تعیین سطح دقیق‌تر می‌کند',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, color: AppColors.textSecondaryLight)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: EngLevel.values.map((l) => _ChoiceCard(
                label: l.farsiLabel,
                selected: selected == l,
                onTap: () => onSelect(l),
                emoji: _levelEmoji(l),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _levelEmoji(EngLevel l) {
    switch (l) {
      case EngLevel.beginner:          return '🌱';
      case EngLevel.elementary:        return '🌿';
      case EngLevel.preIntermediate:   return '🌳';
      case EngLevel.intermediate:      return '💪';
      case EngLevel.upperIntermediate: return '🚀';
    }
  }
}

// ── Time Page ──────────────────────────────────────────────────────────────

class _TimePage extends StatelessWidget {
  final StudyTime? selected;
  final ValueChanged<StudyTime> onSelect;
  const _TimePage({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('چقدر در روز مطالعه می‌کنید؟',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('تداوم از مقدار مهم‌تر است',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, color: AppColors.textSecondaryLight)),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: StudyTime.values.map((t) => _GridChoiceCard(
                label: t.farsiLabel,
                selected: selected == t,
                onTap: () => onSelect(t),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Period Page ──────────────────────────────────────────────────────────────

class _PeriodPage extends StatelessWidget {
  final StudyPeriod? selected;
  final ValueChanged<StudyPeriod> onSelect;
  const _PeriodPage({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('چه وقتی مطالعه می‌کنید؟',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('یادآوری هوشمند در بهترین زمان',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, color: AppColors.textSecondaryLight)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: StudyPeriod.values.map((p) => _ChoiceCard(
                label: p.farsiLabel,
                selected: selected == p,
                onTap: () => onSelect(p),
                emoji: _periodEmoji(p),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _periodEmoji(StudyPeriod p) {
    switch (p) {
      case StudyPeriod.earlyMorning: return '🌅';
      case StudyPeriod.morning:      return '☀️';
      case StudyPeriod.afternoon:    return '🌤️';
      case StudyPeriod.evening:      return '🌆';
      case StudyPeriod.night:        return '🌙';
    }
  }
}

// ── Shared Widgets ──────────────────────────────────────────────────────────

class _ChoiceCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? emoji;
  const _ChoiceCard({required this.label, required this.selected, required this.onTap, this.emoji});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.dividerLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (emoji != null) ...[
              Text(emoji!, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColors.primary : null,
                ),
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _GridChoiceCard extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _GridChoiceCard({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.dividerLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.primary : null,
            ),
          ),
        ),
      ),
    );
  }
}
