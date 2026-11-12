import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../core/widgets/pouyanly_icon.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/persian_digits.dart';
import '../../../core/widgets/animated_game_icons.dart';
import '../../../core/widgets/liquid_glass.dart';
import '../../../shared/providers/user_provider.dart';
import '../../lessons/models/lesson_data.dart';

class LearningPathScreen extends StatelessWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    // CourseData owns the canonical A1→A2→B1→B2→C1→C2 order. Goals may
    // highlight relevant topics, but must never reorder prerequisites.
    final units = CourseData.getAllUnits();
    final completedIds = user?.completedLessonIds ?? const <String>[];
    final completedIdSet = completedIds.toSet();
    final allLessons = units.expand((unit) => unit.lessons).toList();
    final completedLessons = allLessons.where((lesson) => completedIdSet.contains(lesson.id)).length;
    final nextLessonId = LearningPathPolicy.nextLessonId(units: units, completedIds: completedIdSet);
    final totalLessons = units.fold<int>(0, (sum, unit) => sum + unit.lessons.length);
    final pathItems = <Widget>[];
    String? previousLevel;
    for (var index = 0; index < units.length; index++) {
      final unit = units[index];
      if (unit.cefrLevel != previousLevel) {
        previousLevel = unit.cefrLevel;
        final levelUnits = units.where((item) => item.cefrLevel == unit.cefrLevel).toList();
        final levelLessons = levelUnits.expand((item) => item.lessons).toList();
        final levelCompleted = levelLessons.where((lesson) => completedIdSet.contains(lesson.id)).length;
        pathItems.add(_CefrLevelHeader(level: unit.cefrLevel, completed: levelCompleted, total: levelLessons.length));
      }
      final completed = unit.lessons.where((lesson) => completedIdSet.contains(lesson.id)).length;
      pathItems.add(_MapUnitNode(
        unit: unit, completed: completed,
        isUnlocked: LearningPathPolicy.isUnitUnlocked(units: units, unitIndex: index, completedIds: completedIdSet),
        completedIds: completedIds, alignLeft: index.isOdd, nextLessonId: nextLessonId,
        allLessonIds: allLessons.map((lesson) => lesson.id).toList(growable: false),
        goalRecommended: user?.goal != null && _goalPriority(unit, user!.goal!.name) == 0,
      ));
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 292,
          toolbarHeight: 64,
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          title: const Text(
            'مسیر یادگیری',
            style: TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: Center(
                child: _HeaderCounter(
                  icon: Icons.local_fire_department_rounded,
                  value: toPersianDigits(user?.streak ?? 0),
                  color: const Color(0xFFFFB45B),
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _LearningPathHeader(
              name: user?.firstName ?? user?.name ?? 'زبان‌آموز',
              streak: user?.streak ?? 0,
              xp: user?.xp ?? 0,
              coins: user?.coins ?? 0,
              completed: completedLessons,
              total: totalLessons,
            ),
          ),
        ),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: .24), blurRadius: 24, offset: const Offset(0, 12)), const BoxShadow(color: Colors.white24, blurRadius: 2, offset: Offset(-2, -2))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('مسیرت تا تسلط انگلیسی', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
              const SizedBox(height: 6),
              const Text('هر جزیره یک موضوع، هر گره یک درس؛ با کامل کردن درس‌ها مسیر بعدی باز می‌شود.', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, height: 1.7, fontSize: 12)),
              const SizedBox(height: 16),
              ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: totalLessons == 0 ? 0 : completedLessons / totalLessons, minHeight: 10, backgroundColor: Colors.white30, valueColor: const AlwaysStoppedAnimation(Colors.white))),
              const SizedBox(height: 8),
              Text(toPersianDigits(totalLessons == 0 ? 0 : (completedLessons / totalLessons * 100).round()) + '٪ از مسیر تکمیل شده', style: const TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: 11)),
            ]),
          ),
        )),
        SliverPadding(padding: const EdgeInsets.fromLTRB(14, 24, 14, 30), sliver: SliverList(delegate: SliverChildListDelegate(pathItems))),
      ]),
    );
  }
}

class _HeaderCounter extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  const _HeaderCounter({required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: .22)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        icon == Icons.local_fire_department_rounded
            ? const AnimatedFlameIcon(size: 19)
            : Icon(icon, size: 18, color: color),
        const SizedBox(width: 5),
        Text(value, style: const TextStyle(
          fontFamily: 'Vazirmatn', color: Colors.white,
          fontSize: 12, fontWeight: FontWeight.w800)),
      ]),
    );
  }
}

class _CefrLevelHeader extends StatelessWidget {
  final String level; final int completed; final int total;
  const _CefrLevelHeader({required this.level, required this.completed, required this.total});
  String get _title => switch (level) {
    'A1' => 'شروع از پایه', 'A2' => 'مقدماتی', 'B1' => 'متوسط',
    'B2' => 'متوسط رو به بالا', 'C1' => 'پیشرفته', 'C2' => 'تسلط پیشرفته', _ => 'مسیر یادگیری',
  };
  @override Widget build(BuildContext context) {
    final color = AppColors.cefrColor(level);
    final progress = total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0).toDouble();
    return Padding(padding: const EdgeInsetsDirectional.fromSTEB(4, 14, 4, 18), child: Row(children: [
      Container(width: 48, height: 48, alignment: Alignment.center,
        decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(15), border: Border.all(color: color.withValues(alpha: .45))),
        child: Text(level, style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, fontWeight: FontWeight.w900, color: color))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(_title, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 14, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        Text('${toPersianDigits(completed)} از ${toPersianDigits(total)} درس', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 7),
        ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: progress, minHeight: 5, backgroundColor: color.withValues(alpha: .12), valueColor: AlwaysStoppedAnimation<Color>(color))),
      ])),
    ]));
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
  final bool goalRecommended;
  const _MapUnitNode({required this.unit, required this.completed, required this.isUnlocked, required this.completedIds, required this.alignLeft, required this.nextLessonId, required this.allLessonIds, this.goalRecommended = false});
  @override
  State<_MapUnitNode> createState() => _MapUnitNodeState();
}

class _MapUnitNodeState extends State<_MapUnitNode> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    final done = widget.completed == widget.unit.lessons.length;
    final levelColor = AppColors.primary;
    final statusColor = done ? AppColors.success : widget.isUnlocked ? levelColor : Theme.of(context).colorScheme.onSurfaceVariant;
    final bubble = Material(
      elevation: widget.isUnlocked ? 9 : 1,
      shadowColor: statusColor.withValues(alpha: .32),
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: widget.isUnlocked ? () => setState(() => expanded = !expanded) : null,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Theme.of(context).cardColor, statusColor.withValues(alpha: .07)]),
            border: Border.all(color: statusColor.withValues(alpha: .45), width: 1.4),
            boxShadow: [BoxShadow(color: statusColor.withValues(alpha: .13), blurRadius: 20, offset: const Offset(0, 9)), const BoxShadow(color: Colors.white24, blurRadius: 2, offset: Offset(-2, -2))]),
          child: Row(children: [
            Container(width: 58, height: 58, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [statusColor.withValues(alpha: .24), statusColor.withValues(alpha: .08)]), border: Border.all(color: statusColor.withValues(alpha: .35), width: 2), boxShadow: [BoxShadow(color: statusColor.withValues(alpha: .16), blurRadius: 12, offset: const Offset(0, 5))]),
              child: Center(child: widget.isUnlocked ? AnimatedSymbolIcon(symbol: widget.unit.emoji, size: 31, color: statusColor) : const PouyanlyIcon(type: PouyanlyIconType.locked, size: 25))),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (done) const Text('تکمیل شد', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w700)),
              if (widget.goalRecommended) Text('مرتبط با هدف تو', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 10, color: AppColors.cefrColor(widget.unit.cefrLevel), fontWeight: FontWeight.w800)),
              const SizedBox(height: 5),
              Text(widget.unit.titleFarsi, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 14, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(toPersianDigits(widget.completed) + '/' + toPersianDigits(widget.unit.lessons.length) + ' مرحله', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: statusColor)),
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
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: .65),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: levelColor.withValues(alpha: .2)),
            ),
            child: Column(
              children: [
                ...widget.unit.lessons.map((lesson) {
                  final lessonDone = widget.completedIds.contains(lesson.id);
                  return ListTile(
                    dense: true,
                    onTap: lessonDone || (lesson.id == widget.nextLessonId && LearningPathPolicy.isLessonUnlocked(units: CourseData.getAllUnits(), lessonId: lesson.id, completedIds: widget.completedIds.toSet()))
                        ? () => context.push('/lesson/' + lesson.id)
                        : () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('برای باز شدن این مرحله، ابتدا مرحلهٔ قبلی را کامل کن.')),
                            ),
                    leading: CircleAvatar(
                      radius: 17,
                      backgroundColor: levelColor.withValues(alpha: .12),
                      child: AnimatedSymbolIcon(symbol: lesson.emoji, size: 19, color: levelColor),
                    ),
                    title: Text(lesson.titleFarsi, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, fontWeight: FontWeight.w700)),
                    subtitle: Text(
                      '${toPersianDigits(lesson.vocabulary.length)} واژه • ${toPersianDigits(lesson.exercises.length)} تمرین • ${toPersianDigits(lesson.estimatedMinutes)} دقیقه',
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
                            : Icon(Icons.lock_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
      ..color = color.withValues(alpha: .42)
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



class _LearningPathHeader extends StatefulWidget {
  final String name;
  final int xp;
  final int coins;
  final int completed;
  final int total;
  final int streak;

  const _LearningPathHeader({
    required this.name,
    required this.xp,
    required this.coins,
    required this.completed,
    required this.total,
    required this.streak,
  });

  @override
  State<_LearningPathHeader> createState() => _LearningPathHeaderState();
}

class _LearningPathHeaderState extends State<_LearningPathHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambientController;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.total == 0
        ? 0.0
        : (widget.completed / widget.total).clamp(0.0, 1.0).toDouble();

    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF10152D),
                Color(0xFF29245E),
                Color(0xFF56318C),
                Color(0xFF27204F),
              ],
              stops: [0, .34, .72, 1],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _ambientController,
          builder: (context, child) {
            final t = _ambientController.value * math.pi * 2;
            return Stack(
              children: [
                Positioned(
                  top: -90 + 18 * math.sin(t),
                  left: -58 + 22 * math.cos(t),
                  child: const _HeaderOrb(
                    size: 230,
                    color: Color(0xFFB99AFF),
                    opacity: .20,
                  ),
                ),
                Positioned(
                  top: 42 + 14 * math.cos(t),
                  right: -100 + 18 * math.sin(t),
                  child: const _HeaderOrb(
                    size: 210,
                    color: Color(0xFF6EDCFF),
                    opacity: .15,
                  ),
                ),
                Positioned(
                  bottom: -155 + 12 * math.sin(t + 1),
                  left: 100 + 16 * math.cos(t + 1),
                  child: const _HeaderOrb(
                    size: 260,
                    color: Color(0xFFFFA8DE),
                    opacity: .10,
                  ),
                ),
              ],
            );
          },
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: .045),
                    Colors.transparent,
                    Colors.black.withValues(alpha: .13),
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 72, 16, 13),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 720),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 18 * (1 - value)),
                  child: child,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: Image.asset(
                          'assets/images/app_icon.jpg',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'POUYANLY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                letterSpacing: 2.1,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'سلام، ${widget.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Vazirmatn',
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _GlassChip(
                        icon: Icons.local_fire_department_rounded,
                        label: '${toPersianDigits(widget.streak)} روز',
                        tint: const Color(0xFFFFC16E),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'هر روز، یک قدم نزدیک‌تر به تسلط.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            color: Colors.white.withValues(alpha: .76),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      _GlassChip(
                        icon: Icons.auto_awesome_rounded,
                        label: 'مسیر یادگیری',
                        tint: const Color(0xFFC8B5FF),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  _GlassPanel(
                    padding: const EdgeInsets.fromLTRB(10, 11, 10, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: _HeaderMetric(
                            icon: Icons.bolt_rounded,
                            label: 'XP',
                            value: toPersianDigits(widget.xp),
                            tint: const Color(0xFFFFE082),
                          ),
                        ),
                        const _MetricDivider(),
                        Expanded(
                          child: _HeaderMetric(
                            icon: Icons.diamond_rounded,
                            label: 'سکه',
                            value: toPersianDigits(widget.coins),
                            tint: const Color(0xFFFFD180),
                          ),
                        ),
                        const _MetricDivider(),
                        Expanded(
                          child: _HeaderMetric(
                            icon: Icons.flag_rounded,
                            label: 'درس‌ها',
                            value: '${toPersianDigits(widget.completed)}/${toPersianDigits(widget.total)}',
                            tint: const Color(0xFFB9F6CA),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'پیشرفت مسیر',
                              style: TextStyle(
                                fontFamily: 'Vazirmatn',
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: progress),
                                duration: const Duration(milliseconds: 1100),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) =>
                                    LinearProgressIndicator(
                                  value: value,
                                  minHeight: 6,
                                  backgroundColor: Colors.white.withValues(alpha: .18),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Color(0xFFD9C7FF),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${toPersianDigits((progress * 100).round())}٪',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _HeaderOrb({
    required this.size,
    required this.color,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              color.withValues(alpha: opacity * .18),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      );
}

class _GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassPanel({
    required this.child,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) => LiquidGlass(
        padding: padding,
        borderRadius: BorderRadius.circular(23),
        enableBlur: false,
        tint: Theme.of(context).colorScheme.surface,
        child: child,
      );
}

class _GlassChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color tint;

  const _GlassChip({
    required this.icon,
    required this.label,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) => LiquidGlass(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        borderRadius: BorderRadius.circular(30),
        enableBlur: false,
        tint: Theme.of(context).colorScheme.surface,
        showHighlight: false,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: tint),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
}

class _HeaderMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color tint;

  const _HeaderMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: tint),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        color: Colors.white.withValues(alpha: .15),
      );
}
