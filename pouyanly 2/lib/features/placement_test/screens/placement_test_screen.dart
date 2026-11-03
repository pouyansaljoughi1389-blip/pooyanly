import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/p_button.dart';
import '../../../shared/providers/user_provider.dart';
import '../models/placement_question.dart';

class PlacementTestScreen extends StatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen> {
  final List<PlacementQuestion> _questions = PlacementTestData.questions;
  int _current = 0;
  final Map<String, String> _answers = {};
  String? _selectedAnswer;
  bool _showFeedback = false;

  void _select(String ans) {
    if (_showFeedback) return;
    setState(() {
      _selectedAnswer = ans;
      _showFeedback = true;
      _answers[_questions[_current].id] = ans;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _selectedAnswer = null;
        _showFeedback = false;
      });
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final result = PlacementTestData.calculateResult(_answers);
    await context.read<UserProvider>().completePlacementTest(
          cefrLevel: result['cefrLevel'],
          skillScores: Map<String, int>.from(result['skillScores']),
        );
    if (mounted) context.go('/placement-result');
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current];
    final progress = (_current + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'آزمون تعیین سطح',
          style: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go('/welcome'),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // ── Progress Bar ──
            LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.dividerLight,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cefrColor(q.cefrLevel).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      q.cefrLevel,
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.cefrColor(q.cefrLevel),
                      ),
                    ),
                  ),
                  Text(
                    'سوال ${_current + 1} از ${_questions.length}',
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question card
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
                          Text(
                            q.question,
                            style: const TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryLight,
                            ),
                            textDirection: TextDirection.ltr,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            q.questionFarsi,
                            style: const TextStyle(
                              fontFamily: 'Vazirmatn',
                              fontSize: 13,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Options
                    ...q.options.map((opt) => _OptionTile(
                          option: opt,
                          selected: _selectedAnswer == opt,
                          correct: _showFeedback && opt == q.correctAnswer,
                          wrong: _showFeedback && _selectedAnswer == opt && opt != q.correctAnswer,
                          onTap: () => _select(opt),
                        )),

                    // Feedback
                    if (_showFeedback) ...[
                      const SizedBox(height: 16),
                      _FeedbackPanel(
                        correct: _selectedAnswer == q.correctAnswer,
                        explanation: q.explanationFarsi,
                      ),
                    ],
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            if (_showFeedback)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: PButton(
                  label: _current < _questions.length - 1 ? 'سوال بعدی' : 'مشاهده نتایج',
                  onPressed: _next,
                  icon: Icons.arrow_forward_rounded,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String option;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color borderColor = AppColors.dividerLight;
    Color? textColor;

    if (correct) {
      bgColor = AppColors.success.withOpacity(0.12);
      borderColor = AppColors.success;
      textColor = AppColors.success;
    } else if (wrong) {
      bgColor = AppColors.error.withOpacity(0.12);
      borderColor = AppColors.error;
      textColor = AppColors.error;
    } else if (selected) {
      bgColor = AppColors.primary.withOpacity(0.08);
      borderColor = AppColors.primary;
      textColor = AppColors.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (correct) const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
            if (wrong)   const Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
          ],
        ),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  final bool correct;
  final String explanation;
  const _FeedbackPanel({required this.correct, required this.explanation});

  @override
  Widget build(BuildContext context) {
    final color = correct ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(correct ? '✅' : '❌', style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                correct ? 'عالی! پاسخ درست است' : 'پاسخ اشتباه بود',
                style: TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: const TextStyle(
              fontFamily: 'Vazirmatn',
              fontSize: 13,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
