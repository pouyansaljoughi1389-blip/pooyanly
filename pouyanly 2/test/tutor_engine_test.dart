import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/data/models/user_model.dart';
import 'package:pouyanly/features/tutor/services/tutor_engine.dart';

void main() {
  group('Offline tutor scaffold', () {
    test('explains a common agreement error', () {
      final response = TutorEngine.reply(
        message: 'I am agree',
        skillScores: const {'grammar': 40},
        level: CefrLevel.a2,
      );
      expect(response, contains('I agree'));
    });

    test('uses learner skill profile in its general guidance', () {
      final response = TutorEngine.reply(
        message: 'Can you help me?',
        skillScores: const {'vocabulary': 45, 'grammar': 80},
        level: CefrLevel.b1,
      );
      expect(response, contains('واژگان'));
      expect(response, contains('B1'));
    });

    test('looks up vocabulary from advanced course and dictionary', () {
      final courseWord = TutorEngine.reply(
        message: 'What does meticulous mean?',
        skillScores: const {},
        level: CefrLevel.b2,
      );
      expect(courseWord, contains('بسیار دقیق'));
      expect(courseWord, startsWith('سلام، من پویان سلجوقی هستم.'));

      final generalWord = TutorEngine.reply(
        message: 'meaning of opportunity',
        skillScores: const {},
        level: CefrLevel.b2,
      );
      expect(generalWord, contains('فرصت'));
    });

    test('handles empty input without throwing', () {
      expect(
        TutorEngine.reply(message: '  ', skillScores: const {}, level: CefrLevel.a1),
        contains('سؤال'),
      );
    });
  });
}
