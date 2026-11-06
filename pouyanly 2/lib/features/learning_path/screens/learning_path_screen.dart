import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_provider.dart';
import '../../lessons/models/lesson_data.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final units = CourseData.getAllUnits();
    final levelRank = {'A1': 0, 'A2': 1, 'B1': 2, 'B2': 3, 'C1': 4, 'C2': 5};
    units.sort((a, b) {
      final byLevel = (levelRank[a.cefrLevel] ?? 99).compareTo(levelRank[b.cefrLevel] ?? 99);
      if (byLevel != 0) return byLevel;
      final byGoal = _goalPriority(a, user?.goal?.name).compareTo(_goalPriority(b, user?.goal?.name));
      return byGoal != 0 ? byGoal : a.id.compareTo(b.id);
    });
    final completedIds = user?.completedLessonIds ?? const <String>[];
    
    final allLessons = units.expand((u) => u.lessons).toList();
    final completedLessons = allLessons.where((l) => completedIds.contains(l.id)).length;
    String? nextLessonId;
    for (final lesson in allLessons) {
      if (!completedIds.contains(lesson.id)) { nextLessonId = lesson.id; break; }
    }
    final totalLessons = units.fold<int>(0, (sum, unit) => sum + unit.lessons.length);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(slivers: [
        SliverAppBar(pinned: true, title: const Text('نقشهٔ یادگیری'),
          actions: [Padding(padding: const EdgeInsetsDirectional.only(end: 16), child: Center(child: Text(completedLessons.toString() + '/' + totalLessons.toString(), style: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w800))))]),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(.24), blurRadius: 24, offset: const Offset(0, 12)), const BoxShadow(color: Colors.white24, blurRadius: 2, offset: Offset(-2, -2))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('مسیرت تا تسلط انگلیسی', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
              const SizedBox(height: 6),
              const Text('هر جزیره یک موضوع، هر گره یک درس؛ با کامل کردن درس‌ها مسیر بعدی باز می‌شود.', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, height: 1.7, fontSize: 12)),
              const SizedBox(height: 16),
              ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: totalLessons == 0 ? 0 : completedLessons / totalLessons, minHeight: 10, backgroundColor: Colors.white30, valueColor: const AlwaysStoppedAnimation(Colors.white))),
              const SizedBox(height: 8),
              Text((totalLessons == 0 ? 0 : (completedLessons / totalLessons * 100).round()).toString() + '٪ از مسیر تکمیل شده', style: const TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: 11)),
            ]),
          ),
        )),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 18), child: Wrap(spacing: 8, runSpacing: 8, children: ['A1','A2','B1','B2','C1','C2'].map((level) => _LevelPill(level: level)).toList()))),
        SliverPadding(padding: const EdgeInsets.fromLTRB(14, 24, 14, 30), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) {
          final unit = units[index];
          final completed = unit.lessons.where((l) => completedIds.contains(l.id)).length;
          final unlocked = index == 0 ||
              units.take(index).every((previous) => previous.lessons.every((l) => completedIds.contains(l.id)) && completedIds.contains('checkpoint_${previous.id}'));
          return _MapUnitNode(unit: unit, completed: completed, isUnlocked: unlocked, completedIds: completedIds, alignLeft: index.isOdd, nextLessonId: nextLessonId, allLessonIds: allLessons.map((lesson) => lesson.id).toList());
        }, childCount: units.length))),
      ]),
    );
  }
}

class _LevelPill extends StatelessWidget {
  final String level;
  const _LevelPill({required this.level});
  @override
  Widget build(BuildContext context) {
    final color = AppColors.cefrColor(level);
    return Container(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(30), border: Border.all(color: color.withOpacity(.35)), boxShadow: [BoxShadow(color: color.withOpacity(.08), blurRadius: 9, offset: const Offset(0, 4))]),
      child: Text(level, style: TextStyle(fontFamily: 'Vazirmatn', color: color, fontWeight: FontWeight.w900, fontSize: 12)));
  }
}

class _MapUnitNode extends StatefulWidget {
  final Unit unit;
  final int completed;
  final bool isUnlocked;
  final List<String> completedIds;
  final bool alignLeft;
  final String? nextLessonId;
  final List<String> allLessonIds;
  const _MapUnitNode({required this.unit, required this.completed, required this.isUnlocked, required this.completedIds, required this.alignLeft, required this.nextLessonId, required this.allLessonIds});
  @override
  State<_MapUnitNode> createState() => _MapUnitNodeState();
}

class _MapUnitNodeState extends State<_MapUnitNode> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final done = widget.completed == widget.unit.lessons.length;
    final levelColor = AppColors.cefrColor(widget.unit.cefrLevel);
    final statusColor = done ? AppColors.success : widget.isUnlocked ? levelColor : AppColors.textSecondaryLight;
    final bubble = Material(
      elevation: widget.isUnlocked ? 9 : 1,
      shadowColor: statusColor.withOpacity(.32),
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: widget.isUnlocked ? () => setState(() => expanded = !expanded) : null,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Theme.of(context).cardColor, statusColor.withOpacity(.07)]),
            border: Border.all(color: statusColor.withOpacity(.45), width: 1.4),
            boxShadow: [BoxShadow(color: statusColor.withOpacity(.13), blurRadius: 20, offset: const Offset(0, 9)), const BoxShadow(color: Colors.white24, blurRadius: 2, offset: Offset(-2, -2))]),
          child: Row(children: [
            Container(width: 58, height: 58, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [statusColor.withOpacity(.24), statusColor.withOpacity(.08)]), border: Border.all(color: statusColor.withOpacity(.35), width: 2), boxShadow: [BoxShadow(color: statusColor.withOpacity(.16), blurRadius: 12, offset: const Offset(0, 5))]),
              child: Center(child: widget.isUnlocked ? Text(widget.unit.emoji, style: const TextStyle(fontSize: 29)) : const Icon(Icons.lock_rounded, size: 25))),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: levelColor.withOpacity(.13), borderRadius: BorderRadius.circular(20)), child: Text(widget.unit.cefrLevel, style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 10, fontWeight: FontWeight.w900, color: levelColor))),
                const SizedBox(width: 6), if (done) const Text('تکمیل شد', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w700))]),
              const SizedBox(height: 5),
              Text(widget.unit.titleFarsi, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 14, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(widget.completed.toString() + '/' + widget.unit.lessons.length.toString() + ' مرحله', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: statusColor)),
            ])),
            Icon(widget.isUnlocked ? (expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded) : Icons.lock_outline_rounded, color: statusColor),
          ]),
        ),
      ),
    );
    return Padding(padding: EdgeInsets.only(bottom: 16, left: widget.alignLeft ? 30 : 0, right: widget.alignLeft ? 0 : 30),
      child: Column(children: [
        bubble,
        if (expanded && widget.isUnlocked)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(.65),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: levelColor.withOpacity(.2)),
            ),
            child: Column(
              children: [
                ...widget.unit.lessons.map((lesson) {
                  final lessonDone = widget.completedIds.contains(lesson.id);
                  return ListTile(
                    dense: true,
                    onTap: lessonDone || lesson.id == widget.nextLessonId
                        ? () => context.push('/lesson/' + lesson.id)
                        : () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('برای باز شدن این مرحله، ابتدا مرحلهٔ قبلی را کامل کن.')),
                            ),
                    leading: CircleAvatar(
                      radius: 17,
                      backgroundColor: levelColor.withOpacity(.12),
                      child: Text(lesson.emoji, style: const TextStyle(fontSize: 16)),
                    ),
                    title: Text(lesson.titleFarsi, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, fontWeight: FontWeight.w700)),
                    subtitle: Text(
                      '${lesson.vocabulary.length} واژه • ${lesson.exercises.length} تمرین • ${lesson.estimatedMinutes} دقیقه',
                      style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 10),
                    ),
                    trailing: lessonDone
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.success)
                        : lesson.id == widget.nextLessonId
                            ? Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(
                                  tooltip: 'رد کردن با ۱۰۰ XP',
                                  icon: const Icon(Icons.fast_forward_rounded),
                                  onPressed: () async {
                                    final previousIds = widget.allLessonIds.takeWhile((id) => id != lesson.id).toList();
                                    final ok = await context.read<UserProvider>().skipLesson(
                                      lesson.id,
                                      xpCost: 100,
                                      previousLessonIds: previousIds,
                                    );
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(ok ? 'مرحله با پرداخت ۱۰۰ XP رد شد.' : 'برای رد کردن، حداقل ۱۰۰ XP و تکمیل مراحل قبلی لازم است.')),
                                    );
                                  },
                                ),
                                Icon(Icons.play_circle_fill_rounded, color: levelColor),
                              ])
                            : const Icon(Icons.lock_rounded, color: AppColors.textSecondaryLight),
                  );
                }),
                if (done)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => context.push('/checkpoint/${widget.unit.id}'),
                        icon: const Icon(Icons.workspace_premium_rounded),
                        label: Text(
                          widget.completedIds.contains('checkpoint_${widget.unit.id}')
                              ? 'آزمون جزیره را گذرانده‌ای'
                              : 'آزمون جامع جزیره • ۸ سؤال',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(
          height: 42,
          width: double.infinity,
          child: CustomPaint(
            painter: _RouteConnectorPainter(toLeft: widget.alignLeft, color: statusColor),
          ),
        ),
      ]));
  }
}


class _RouteConnectorPainter extends CustomPainter {
  final bool toLeft;
  final Color color;
  const _RouteConnectorPainter({required this.toLeft, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(size.width / 2, 0);
    final end = Offset(size.width / 2 + (toLeft ? -30 : 30), size.height);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(start.dx, size.height * .45, end.dx, size.height * .55, end.dx, end.dy);
    final paint = Paint()
      ..color = color.withOpacity(.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);
    canvas.drawCircle(end, 5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _RouteConnectorPainter oldDelegate) =>
      oldDelegate.toLeft != toLeft || oldDelegate.color != color;
}


int _goalPriority(Unit unit, String? goal) {
  final text = '${unit.title} ${unit.titleFarsi}'.toLowerCase();
  final keywords = switch (goal) {
    'travel' => ['travel', 'transport', 'food', 'hotel', 'shopping', 'greetings', 'directions', 'سفر', 'خرید'],
    'work' => ['work', 'business', 'professional', 'technology', 'communication', 'کار', 'شغل'],
    'study' => ['academic', 'education', 'research', 'university', 'science', 'study', 'دانشگاه', 'تحصیل'],
    'immigration' => ['home', 'health', 'service', 'travel', 'communication', 'daily', 'خانه', 'مهاجرت'],
    'entertainment' => ['movie', 'music', 'hobby', 'culture', 'media', 'story', 'فیلم', 'سرگرمی'],
    'exam' => ['academic', 'grammar', 'vocabulary', 'reading', 'writing', 'exam', 'آزمون', 'گرامر'],
    _ => const <String>[],
  };
  if (keywords.isEmpty) return 0;
  return keywords.any(text.contains) ? 0 : 1;
}
