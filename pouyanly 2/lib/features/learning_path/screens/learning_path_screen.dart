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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('مسیر یادگیری',
                style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final unit = units[i];
                  final completedIds = user?.completedLessonIds ?? [];
                  final completedInUnit = unit.lessons
                      .where((l) => completedIds.contains(l.id))
                      .length;
                  final isActive = i == 0 ||
                      units[i - 1].lessons
                          .every((l) => completedIds.contains(l.id));

                  return _UnitCard(
                    unit: unit,
                    completed: completedInUnit,
                    total: unit.lessons.length,
                    isActive: isActive,
                    completedIds: completedIds,
                  );
                },
                childCount: units.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnitCard extends StatefulWidget {
  final Unit unit;
  final int completed;
  final int total;
  final bool isActive;
  final List<String> completedIds;

  const _UnitCard({
    required this.unit,
    required this.completed,
    required this.total,
    required this.isActive,
    required this.completedIds,
  });

  @override
  State<_UnitCard> createState() => _UnitCardState();
}

class _UnitCardState extends State<_UnitCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final allDone = widget.completed == widget.total;
    final Color headerColor = allDone
        ? AppColors.success
        : widget.isActive
            ? AppColors.primary
            : AppColors.textSecondaryLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Column(
        children: [
          // ── Header ──
          GestureDetector(
            onTap: widget.isActive ? () => setState(() => _expanded = !_expanded) : null,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [headerColor.withOpacity(0.12), headerColor.withOpacity(0.04)],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: headerColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(widget.unit.emoji, style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.cefrColor(widget.unit.cefrLevel).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.unit.cefrLevel,
                                style: TextStyle(
                                  fontFamily: 'Vazirmatn',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.cefrColor(widget.unit.cefrLevel),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.unit.titleFarsi,
                          style: const TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${widget.completed}/${widget.total} درس تکمیل شده',
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 12,
                            color: headerColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!widget.isActive)
                    const Icon(Icons.lock_rounded, color: AppColors.textSecondaryLight, size: 20)
                  else
                    Icon(
                      _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: headerColor,
                    ),
                ],
              ),
            ),
          ),

          // ── Lessons List ──
          if (_expanded && widget.isActive)
            Column(
              children: widget.unit.lessons.map((lesson) {
                final done = widget.completedIds.contains(lesson.id);
                return _LessonRow(lesson: lesson, done: done);
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  final Lesson lesson;
  final bool done;

  const _LessonRow({required this.lesson, required this.done});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/lesson/${lesson.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: done ? AppColors.success.withOpacity(0.15) : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(lesson.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.titleFarsi,
                    style: const TextStyle(
                        fontFamily: 'Vazirmatn', fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${lesson.vocabulary.length} لغت • ${lesson.exercises.length} تمرین',
                    style: const TextStyle(
                        fontFamily: 'Vazirmatn', fontSize: 11, color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.xpColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '+${lesson.xpReward}XP',
                style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              done ? Icons.check_circle_rounded : Icons.play_circle_rounded,
              color: done ? AppColors.success : AppColors.primary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
