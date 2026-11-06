import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/p_button.dart';
import '../../../shared/providers/user_provider.dart';
import '../models/lesson_data.dart';

enum _LessonPhase { vocabulary, exercise, result }

class LessonScreen extends StatefulWidget {
  final String lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  _LessonPhase _phase = _LessonPhase.vocabulary;
  int _vocabIndex = 0;
  int _exerciseIndex = 0;
  int _correct = 0;
  String? _selectedAnswer;
  bool _showFeedback = false;

  late Lesson? _lesson;

  @override
  void initState() {
    super.initState();
    _lesson = CourseData.getLessonById(widget.lessonId);
  }

  void _nextVocab() {
    if (_lesson == null) return;
    if (_vocabIndex < _lesson!.vocabulary.length - 1) {
      setState(() => _vocabIndex++);
    } else {
      setState(() => _phase = _LessonPhase.exercise);
    }
  }

  void _selectAnswer(String ans) {
    if (_showFeedback || _lesson == null) return;
    final exercise = _lesson!.exercises[_exerciseIndex];
    setState(() {
      _selectedAnswer = ans;
      _showFeedback = true;
      if (ans == exercise.correctAnswer) _correct++;
    });
  }

  void _nextExercise() {
    if (_lesson == null) return;
    if (_exerciseIndex < _lesson!.exercises.length - 1) {
      setState(() {
        _exerciseIndex++;
        _selectedAnswer = null;
        _showFeedback = false;
      });
    } else {
      _finishLesson();
    }
  }

  Future<void> _finishLesson() async {
    if (_lesson == null) return;
    final xpGain = _lesson!.xpReward;
    await context.read<UserProvider>().completeLesson(
          _lesson!.id,
          xpGain: xpGain,
          coinGain: 5,
        );
    setState(() => _phase = _LessonPhase.result);
  }

  @override
  Widget build(BuildContext context) {
    if (_lesson == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.go('/home'))),
        body: const Center(child: Text('درس پیدا نشد', style: TextStyle(fontFamily: 'Vazirmatn'))),
      );
    }

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: switch (_phase) {
          _LessonPhase.vocabulary => _VocabPhase(
              lesson: _lesson!,
              index: _vocabIndex,
              onNext: _nextVocab,
            ),
          _LessonPhase.exercise => _ExercisePhase(
              lesson: _lesson!,
              index: _exerciseIndex,
              selected: _selectedAnswer,
              showFeedback: _showFeedback,
              onSelect: _selectAnswer,
              onNext: _nextExercise,
            ),
          _LessonPhase.result => _ResultPhase(
              lesson: _lesson!,
              correct: _correct,
              total: _lesson!.exercises.length,
            ),
        },
      ),
    );
  }
}

// ── Vocabulary Phase ─────────────────────────────────────────────────────────

class _VocabPhase extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final VoidCallback onNext;

  const _VocabPhase({required this.lesson, required this.index, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final vocab = lesson.vocabulary[index];

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => context.go('/home'),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (index + 1) / lesson.vocabulary.length,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(100),
                    backgroundColor: AppColors.dividerLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${index + 1}/${lesson.vocabulary.length}',
                  style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          if (lesson.objectivesFarsi.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'هدف این درس',
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.objectivesFarsi.first,
                      style: const TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lesson.estimatedMinutes} دقیقه • ${lesson.skillFocus.join('، ')}',
                      style: const TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 10,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // Flashcard

          // Next button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: PButton(
              label: index < lesson.vocabulary.length - 1 ? 'بعدی' : 'شروع تمرین‌ها',
              onPressed: onNext,
              icon: Icons.arrow_forward_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashCard extends StatefulWidget {
  final VocabularyItem vocab;
  const _FlashCard({required this.vocab});

  @override
  State<_FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<_FlashCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _flipped = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _anim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(_FlashCard old) {
    super.didUpdateWidget(old);
    if (old.vocab != widget.vocab) {
      _ctrl.reset();
      _flipped = false;
    }
  }

  void _flip() {
    if (_flipped) {
      _ctrl.reverse();
    } else {
      _ctrl.forward();
    }
    setState(() => _flipped = !_flipped);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AnimatedBuilder(
          animation: _anim,
          builder: (ctx, _) {
            final isFront = _anim.value < 0.5;
            final angle = _anim.value * 3.14159;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: isFront ? _CardFront(vocab: widget.vocab) : _CardBack(vocab: widget.vocab),
            );
          },
        ),
      ),
    );
  }
}

class _CardFront extends StatelessWidget {
  final VocabularyItem vocab;
  const _CardFront({required this.vocab});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              vocab.cefrLevel,
              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            vocab.english,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 8),
          Text(
            vocab.pronunciation,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 16,
              color: Colors.white70,
            ),
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 30),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_rounded, color: Colors.white54, size: 18),
              SizedBox(width: 6),
              Text(
                'برای دیدن معنی ضربه بزنید',
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, color: Colors.white54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final VocabularyItem vocab;
  const _CardBack({required this.vocab});

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              vocab.farsi,
              style: const TextStyle(
                fontFamily: 'Vazirmatn',
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    vocab.exampleEn,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 14,
                      color: AppColors.textSecondaryLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vocab.exampleFa,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Exercise Phase ────────────────────────────────────────────────────────────

class _ExercisePhase extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final String? selected;
  final bool showFeedback;
  final ValueChanged<String> onSelect;
  final VoidCallback onNext;

  const _ExercisePhase({
    required this.lesson,
    required this.index,
    required this.selected,
    required this.showFeedback,
    required this.onSelect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final exercise = lesson.exercises[index];

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => context.go('/home'),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (index + 1) / lesson.exercises.length,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(100),
                    backgroundColor: AppColors.dividerLight,
                    valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${index + 1}/${lesson.exercises.length}',
                  style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.dividerLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercise.question,
                            style: const TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            textDirection: TextDirection.ltr),
                        const SizedBox(height: 6),
                        Text(exercise.questionFarsi,
                            style: const TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 13,
                              color: AppColors.textSecondaryLight,
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...exercise.options.map((opt) {
                    bool isCorrect = showFeedback && opt == exercise.correctAnswer;
                    bool isWrong = showFeedback && selected == opt && opt != exercise.correctAnswer;
                    return _OptionTile(
                      text: opt,
                      isCorrect: isCorrect,
                      isWrong: isWrong,
                      isSelected: selected == opt,
                      onTap: () => onSelect(opt),
                    );
                  }),
                  if (showFeedback) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: (selected == exercise.correctAnswer ? AppColors.success : AppColors.error).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (selected == exercise.correctAnswer ? AppColors.success : AppColors.error).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selected == exercise.correctAnswer ? '✅ عالی! درست است' : '❌ اشتباه بود',
                            style: TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: selected == exercise.correctAnswer ? AppColors.success : AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(exercise.explanationFarsi,
                              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, color: AppColors.textSecondaryLight)),
                          if (exercise.exampleEn != null) ...[
                            const SizedBox(height: 8),
                            Text(exercise.exampleEn!,
                                style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, fontStyle: FontStyle.italic),
                                textDirection: TextDirection.ltr),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          if (showFeedback)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: PButton(
                label: index < lesson.exercises.length - 1 ? 'بعدی' : 'پایان درس',
                onPressed: onNext,
                icon: Icons.arrow_forward_rounded,
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isWrong;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.text,
    required this.isCorrect,
    required this.isWrong,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color border = AppColors.dividerLight;
    Color? bg;

    if (isCorrect) { border = AppColors.success; bg = AppColors.success.withOpacity(0.1); }
    else if (isWrong) { border = AppColors.error; bg = AppColors.error.withOpacity(0.1); }
    else if (isSelected) { border = AppColors.primary; bg = AppColors.primary.withOpacity(0.06); }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            if (isCorrect) const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
            if (isWrong)   const Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Result Phase ──────────────────────────────────────────────────────────────

class _ResultPhase extends StatelessWidget {
  final Lesson lesson;
  final int correct;
  final int total;

  const _ResultPhase({required this.lesson, required this.correct, required this.total});

  @override
  Widget build(BuildContext context) {
    final accuracy = total > 0 ? (correct / total * 100).round() : 0;
    final emoji = accuracy >= 80 ? '🎉' : accuracy >= 50 ? '👍' : '💪';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            Text(
              accuracy >= 80 ? 'عالی بود!' : accuracy >= 50 ? 'خوب بود!' : 'ادامه بده!',
              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'درس "${lesson.titleFarsi}" تکمیل شد',
              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 15, color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StatBadge('$correct/$total', 'درست', AppColors.success),
                const SizedBox(width: 16),
                _StatBadge('$accuracy%', 'دقت', AppColors.primary),
                const SizedBox(width: 16),
                _StatBadge('+${lesson.xpReward}', 'XP', AppColors.warning),
              ],
            ),
            const SizedBox(height: 40),
            PButton(
              label: 'ادامه',
              onPressed: () => context.go('/home'),
              icon: Icons.home_rounded,
            ),
            const SizedBox(height: 12),
            PButton(
              label: 'تکرار درس',
              outlined: true,
              onPressed: () => context.go('/lesson/${lesson.id}'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatBadge(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 20, fontWeight: FontWeight.w800, color: color)),
          Text(label,
              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, color: AppColors.textSecondaryLight)),
        ],
      ),
    );
  }
}
