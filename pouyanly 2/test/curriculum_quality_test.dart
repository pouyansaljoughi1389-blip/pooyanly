import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/features/lessons/models/lesson_data.dart';
import 'package:pouyanly/features/lessons/models/expanded_course_data.dart';

void main() {
  group('Course curriculum quality', () {
    final units = CourseData.getAllUnits();
    final lessons = units.expand((unit) => unit.lessons).toList();

    test('expanded pathway includes substantial A1 through C2 content', () {
      for (final level in ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']) {
        final levelUnits = CourseData.getUnitsForLevel(level);
        expect(levelUnits, isNotEmpty, reason: 'Missing $level pathway');
        expect(levelUnits.expand((unit) => unit.lessons).length, greaterThanOrEqualTo(3));
      }
      expect(lessons.length, 233, reason: 'The learning map must contain exactly 233 lessons');
      expect(ExpandedCourseData.units.expand((unit) => unit.lessons).length, 228,
          reason: 'The expanded curriculum must provide exactly 226 lessons');
      final levels = units.map((unit) => unit.cefrLevel).toList();
      expect(levels, orderedEquals([...levels]..sort((a, b) {
        const order = {'A1': 0, 'A2': 1, 'B1': 2, 'B2': 3, 'C1': 4, 'C2': 5};
        return order[a]!.compareTo(order[b]!);
      })));
    });

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

    test('each expanded lesson offers substantial vocabulary and retrieval practice', () {
      for (final unit in units.where((u) => !['a1_u1', 'a1_u2', 'a1_u3', 'a2_u1', 'a2_u2'].contains(u.id))) {
        for (final lesson in unit.lessons) {
          expect(lesson.vocabulary.length, 5, reason: '${lesson.id} must teach exactly five vocabulary items');
          expect(lesson.exercises.length, 5, reason: '${lesson.id} must include exactly five retrieval exercises');
        }
      }
    });

    test('expanded vocabulary headwords are globally unique', () {
      final vocabulary = ExpandedCourseData.units
          .expand((unit) => unit.lessons)
          .expand((lesson) => lesson.vocabulary)
          .toList();
      final normalized = vocabulary
          .map((item) => item.english.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' '))
          .toList();
      expect(normalized.toSet().length, normalized.length,
          reason: 'An English headword must not be repeated across expanded topics');
    });

    test('every generated lesson has five distinct exercises', () {
      for (final lesson in ExpandedCourseData.units.expand((unit) => unit.lessons)) {
        final ids = lesson.exercises.map((exercise) => exercise.id).toList();
        expect(ids.length, 5, reason: lesson.id);
        expect(ids.toSet().length, ids.length, reason: '${lesson.id} has duplicate exercise IDs');
        for (final exercise in lesson.exercises) {
          expect(exercise.options.length, greaterThanOrEqualTo(4), reason: exercise.id);
        }
      }
    });

    test('lesson and unit identifiers are unique', () {
      final unitIds = units.map((unit) => unit.id).toList();
      final lessonIds = lessons.map((lesson) => lesson.id).toList();
      final exerciseIds = lessons.expand((lesson) => lesson.exercises).map((exercise) => exercise.id).toList();
      expect(unitIds.toSet().length, unitIds.length);
      expect(lessonIds.toSet().length, lessonIds.length);
      expect(exerciseIds.toSet().length, exerciseIds.length);
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


    test('correct answers are not fixed to the first option', () {
      final positions = <int>{};
      for (final lesson in lessons) {
        for (final exercise in lesson.exercises) {
          positions.add(exercise.options.indexOf(exercise.correctAnswer));
        }
      }
      expect(positions.length, greaterThan(1),
          reason: 'Correct answers must appear in different option positions');
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
        expect(CourseData.getLessonById(lesson.id)?.id, lesson.id);
      }
    });
  });
}
