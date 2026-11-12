import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/features/lessons/models/lesson_data.dart';

void main() {
  group('CourseData.getAllVocabulary', () {
    test('returns only one dictionary entry per English headword', () {
      final vocabulary = CourseData.getAllVocabulary();
      final keys = vocabulary
          .map((item) => item.english.trim().toLowerCase().replaceAll(RegExp(r'\\s+'), ' '))
          .toList();

      expect(keys.toSet().length, keys.length);
      expect(keys, contains('deadline'));
      expect(keys, contains('stakeholder'));
    });

    test('does not mutate lesson vocabulary used by the learning path', () {
      final rawCount = CourseData.getAllUnits()
          .expand((unit) => unit.lessons)
          .fold<int>(0, (count, lesson) => count + lesson.vocabulary.length);

      expect(CourseData.getAllVocabulary().length, lessThanOrEqualTo(rawCount));
      expect(rawCount, greaterThan(CourseData.getAllVocabulary().length));
    });
  });
}
