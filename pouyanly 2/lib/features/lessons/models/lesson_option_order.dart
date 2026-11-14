import 'dart:math';

import 'lesson_data.dart';

/// Produces a repeatable, lesson-specific option order without changing the
/// answer key. A learner sees a stable order during retries, but correct
/// answers are not tied to the first option in the curriculum data.
class LessonOptionOrder {
  LessonOptionOrder._();

  static List<String> forExercise({
    required String lessonId,
    required Exercise exercise,
  }) {
    final options = List<String>.of(exercise.options);
    if (options.length < 2) return options;

    var seed = 0x811C9DC5;
    for (final unit in '$lessonId:${exercise.id}'.codeUnits) {
      seed = ((seed ^ unit) * 0x01000193) & 0x7fffffff;
    }
    options.shuffle(Random(seed));

    if (_sameOrder(options, exercise.options)) {
      options.add(options.removeAt(0));
    }
    return options;
  }

  static bool _sameOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }
}
