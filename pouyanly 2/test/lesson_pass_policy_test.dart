import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/features/lessons/models/lesson_data.dart';

void main() {
  group('Lesson pass threshold', () {
    test('a zero score cannot unlock the next lesson', () {
      expect(LessonPassPolicy.isPassed(correct: 0, total: 6), isFalse);
    });

    test('scores below seventy percent fail', () {
      expect(LessonPassPolicy.isPassed(correct: 4, total: 6), isFalse);
      expect(LessonPassPolicy.isPassed(correct: 6, total: 10), isFalse);
    });

    test('seventy percent or more passes', () {
      expect(LessonPassPolicy.isPassed(correct: 5, total: 6), isTrue);
      expect(LessonPassPolicy.isPassed(correct: 7, total: 10), isTrue);
    });

    test('empty or invalid result cannot pass', () {
      expect(LessonPassPolicy.isPassed(correct: 0, total: 0), isFalse);
      expect(LessonPassPolicy.isPassed(correct: 8, total: 6), isFalse);
    });
  });
  group('CEFR learning path policy', () {
    test('curriculum includes all six CEFR levels in canonical order', () {
      final units = CourseData.getAllUnits();
      const rank = {'A1': 0, 'A2': 1, 'B1': 2, 'B2': 3, 'C1': 4, 'C2': 5};
      final levels = units.map((unit) => unit.cefrLevel).toSet();
      expect(levels, containsAll(rank.keys));
      for (var index = 1; index < units.length; index++) {
        expect(rank[units[index].cefrLevel], greaterThanOrEqualTo(rank[units[index - 1].cefrLevel]!));
      }
    });
    test('only the first unit starts unlocked', () {
      final units = CourseData.getAllUnits();
      final empty = <String>{};
      expect(LearningPathPolicy.isUnitUnlocked(units: units, unitIndex: 0, completedIds: empty), isTrue);
      expect(LearningPathPolicy.isUnitUnlocked(units: units, unitIndex: 1, completedIds: empty), isFalse);
      expect(LearningPathPolicy.nextLessonId(units: units, completedIds: empty), units.first.lessons.first.id);
    });
    test('next unit requires all prior lessons and the previous checkpoint', () {
      final units = CourseData.getAllUnits();
      final first = units.first;
      final completed = first.lessons.map((lesson) => lesson.id).toSet();
      expect(LearningPathPolicy.isUnitUnlocked(units: units, unitIndex: 1, completedIds: completed), isFalse);
      completed.add('checkpoint_${first.id}');
      expect(LearningPathPolicy.isUnitUnlocked(units: units, unitIndex: 1, completedIds: completed), isTrue);
    });
    test('lessons within a unit unlock sequentially', () {
      final units = CourseData.getAllUnits();
      final first = units.first;
      final completed = <String>{};
      expect(LearningPathPolicy.isLessonUnlocked(units: units, lessonId: first.lessons.first.id, completedIds: completed), isTrue);
      expect(LearningPathPolicy.isLessonUnlocked(units: units, lessonId: first.lessons[1].id, completedIds: completed), isFalse);
      completed.add(first.lessons.first.id);
      expect(LearningPathPolicy.isLessonUnlocked(units: units, lessonId: first.lessons[1].id, completedIds: completed), isTrue);
      expect(LearningPathPolicy.isLessonUnlocked(units: units, lessonId: 'not-a-real-lesson', completedIds: completed), isFalse);
    });
  });

}