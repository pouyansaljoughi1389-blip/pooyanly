import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_provider.dart';
import '../../lessons/models/lesson_data.dart';

class CheckpointScreen extends StatefulWidget {
  final String unitId;
  const CheckpointScreen({super.key, required this.unitId});

  @override
  State<CheckpointScreen> createState() => _CheckpointScreenState();
}

class _CheckpointScreenState extends State<CheckpointScreen> {
  int _index = 0;
  final Map<int, String> _answers = {};
  bool _busy = false;

  Unit? get _unit {
    for (final unit in CourseData.getAllUnits()) {
      if (unit.id == widget.unitId) return unit;
    }
    return null;
  }

  List<Exercise> get _questions =>
      _unit?.lessons.expand((lesson) => lesson.exercises).take(8).toList() ?? const [];

  Future<void> _finish() async {
    if (_busy || _questions.isEmpty) return;
    setState(() => _busy = true);
    final correct = _questions.asMap().entries
        .where((entry) => _answers[entry.key] == entry.value.correctAnswer)
        .length;
    final percent = (correct / _questions.length * 100).round();
    final passed = percent >= 70;
    if (passed) {
      await context.read<UserProvider>().completeCheckpoint(widget.unitId);
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(passed ? 'جزیره فتح شد! 🎉' : 'یک بار دیگر تلاش کن'),
        content: Text('$correct از ${_questions.length} پاسخ درست بود؛ دقت تو $percent٪ است. '
            '${passed ? '۵۰ XP و ۱۰ سکه گرفتی و مسیر بعدی باز شد.' : 'برای باز شدن مسیر بعدی باید حداقل ۷۰٪ بگیری.'}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (passed) context.pop();
              else setState(() { _index = 0; _answers.clear(); _busy = false; });
            },
            child: Text(passed ? 'ادامه مسیر' : 'تکرار آزمون'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unit = _unit;
    final questions = _questions;
    if (unit == null || questions.isEmpty) {
      return Scaffold(appBar: AppBar(title: const Text('آزمون جزیره')), body: const Center(child: Text('آزمون این بخش پیدا نشد.')));
    }
    final completedIds = context.watch<UserProvider>().user?.completedLessonIds ?? const <String>[];
    final unitLessonsPassed = unit.lessons.every((lesson) => completedIds.contains(lesson.id));
    if (!unitLessonsPassed) {
      return Scaffold(
        appBar: AppBar(title: const Text('آزمون جامع بخش')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Text(
              'برای شرکت در آزمون جامع، ابتدا باید تمام درس‌های این بخش را با حدنصاب قبولی بگذرانی.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15, height: 1.8),
            ),
          ),
        ),
      );
    }
    final question = questions[_index];
    final selected = _answers[_index];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('آزمون جامع: ${unit.titleFarsi}')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('مرحله ${_index + 1} از ${questions.length}', style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(value: (_index + 1) / questions.length, minHeight: 9),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Theme.of(context).cardColor, AppColors.cefrColor(unit.cefrLevel).withValues(alpha: .12)]),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: AppColors.cefrColor(unit.cefrLevel).withValues(alpha: .3)),
                    boxShadow: [BoxShadow(color: AppColors.cefrColor(unit.cefrLevel).withValues(alpha: .16), blurRadius: 24, offset: const Offset(0, 10))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(question.question, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    Text(question.questionFarsi, style: const TextStyle(fontSize: 13, height: 1.7)),
                  ]),
                ),
                const SizedBox(height: 18),
                ...question.options.map((option) => Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Material(
                    color: selected == option ? AppColors.primary.withValues(alpha: .13) : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => setState(() => _answers[_index] = option),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: selected == option ? AppColors.primary : AppColors.dividerLight, width: selected == option ? 2 : 1)),
                        child: Text(option, textDirection: TextDirection.ltr, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                )),
                const Spacer(),
                FilledButton(
                  onPressed: selected == null || _busy ? null : () {
                    if (_index < questions.length - 1) setState(() => _index++);
                    else _finish();
                  },
                  child: Text(_index == questions.length - 1 ? 'ثبت نتیجه آزمون' : 'سؤال بعدی'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
