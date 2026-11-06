import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/features/lessons/models/lesson_data.dart';

void main() {
  group('Course curriculum quality', () {
    final units = CourseData.getAllUnits();
    final lessons = units.expand((unit) => unit.lessons).toList();

    test('every published lesson has a measurable objective and skill focus', () {
      expect(lessons, isNotEmpty);
      for (final lesson in lessons) {
        expect(lesson.objectivesFarsi, isNotEmpty,
            reason: '${lesson.id} must define at least one learning objective');
        expect(lesson.skillFocus, isNotEmpty,
            reason: '${lesson.id} must identify its target skills');
        expect(lesson.estimatedMinutes, greaterThan(0));
      }
    });

    test('lesson and unit identifiers are unique', () {
      final unitIds = units.map((unit) => unit.id).toList();
      final lessonIds = lessons.map((lesson) => lesson.id).toList();
      expect(unitIds.toSet().length, unitIds.length);
      expect(lessonIds.toSet().length, lessonIds.length);
    });

    test('every exercise has a selectable correct answer', () {
      for (final lesson in lessons) {
        expect(lesson.vocabulary, isNotEmpty,
            reason: '${lesson.id} must teach vocabulary');
        expect(lesson.exercises, isNotEmpty,
            reason: '${lesson.id} must include retrieval practice');
        for (final exercise in lesson.exercises) {
          expect(exercise.options, contains(exercise.correctAnswer),
              reason: '${exercise.id} correct answer must be one of its options');
          expect(exercise.explanationFarsi.trim(), isNotEmpty,
              reason: '${exercise.id} must explain the answer');
        }
      }
    });

    test('vocabulary examples and translations are complete', () {
      for (final lesson in lessons) {
        for (final item in lesson.vocabulary) {
          expect(item.english.trim(), isNotEmpty);
          expect(item.farsi.trim(), isNotEmpty);
          expect(item.exampleEn.trim(), isNotEmpty);
          expect(item.exampleFa.trim(), isNotEmpty);
        }
      }
    });

    test('course lookup returns each lesson by its stable identifier', () {
      for (final lesson in lessons) {
        expect(CourseData.getLessonById(lesson.id), same(lesson));
      }
    });
  });
}
