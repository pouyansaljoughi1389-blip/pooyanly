import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/data/models/user_model.dart';
import 'package:pouyanly/features/placement_test/models/placement_question.dart';

void main() {
  group('Placement assessment', () {
    test('all correct answers reach the highest level currently assessed', () {
      final answers = {
        for (final question in PlacementTestData.questions)
          question.id: question.correctAnswer,
      };
      final result = PlacementTestData.calculateResult(answers);
      expect(result['cefrLevel'], CefrLevel.b2);
      expect(result['answeredCount'], PlacementTestData.questions.length);
      expect(result['skillScores'].keys,
          containsAll(['vocabulary', 'grammar', 'reading']));
    });

    test('higher-level answers cannot bypass a failed prerequisite level', () {
      final answers = <String, String>{};
      for (final question in PlacementTestData.questions) {
        if (question.cefrLevel == 'A1' || question.cefrLevel == 'A2') {
          answers[question.id] = question.correctAnswer;
        } else if (question.cefrLevel == 'B1' || question.cefrLevel == 'B2') {
          answers[question.id] = 'deliberately incorrect';
        }
      }
      final result = PlacementTestData.calculateResult(answers);
      expect(result['cefrLevel'], CefrLevel.a2);
    });

    test('unanswered questions are excluded from skill accuracy', () {
      final firstVocabulary = PlacementTestData.questions.firstWhere(
        (question) => question.skill == 'vocabulary',
      );
      final result = PlacementTestData.calculateResult({
        firstVocabulary.id: firstVocabulary.correctAnswer,
      });
      expect(result['skillScores']['vocabulary'], 100);
      expect(result['skillScores'].containsKey('grammar'), isFalse);
      expect(result['answeredCount'], 1);
    });

    test('empty submission returns unknown instead of guessing A1', () {
      final result = PlacementTestData.calculateResult({});
      expect(result['cefrLevel'], CefrLevel.unknown);
      expect(result['skillScores'], isEmpty);
      expect(result['answeredCount'], 0);
    });
  });
}
