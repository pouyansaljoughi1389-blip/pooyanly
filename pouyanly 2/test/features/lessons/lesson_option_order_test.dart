import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/features/lessons/models/lesson_data.dart';
import 'package:pouyanly/features/lessons/models/lesson_option_order.dart';

void main() {
  group('LessonOptionOrder', () {
    test('keeps all options and the correct answer intact', () {
      for (final unit in CourseData.getAllUnits()) {
        for (final lesson in unit.lessons) {
          for (final exercise in lesson.exercises) {
            final ordered = LessonOptionOrder.forExercise(
              lessonId: lesson.id,
              exercise: exercise,
            );
            expect(ordered.toSet(), exercise.options.toSet());
            expect(ordered.length, exercise.options.length);
            expect(ordered, contains(exercise.correctAnswer));
          }
        }
      }
    });

    test('is stable for retries of the same lesson exercise', () {
      final lesson = CourseData.getAllUnits().first.lessons.first;
      final exercise = lesson.exercises.first;
      expect(
        LessonOptionOrder.forExercise(lessonId: lesson.id, exercise: exercise),
        LessonOptionOrder.forExercise(lessonId: lesson.id, exercise: exercise),
      );
    });

    test('correct answers are distributed across positions', () {
      final positions = <int>{};
      for (final unit in CourseData.getAllUnits()) {
        for (final lesson in unit.lessons) {
          for (final exercise in lesson.exercises) {
            if (exercise.options.length < 2) continue;
            final ordered = LessonOptionOrder.forExercise(
              lessonId: lesson.id,
              exercise: exercise,
            );
            positions.add(ordered.indexOf(exercise.correctAnswer));
          }
        }
      }
      expect(positions.length, greaterThan(1));
    });
  });
}
