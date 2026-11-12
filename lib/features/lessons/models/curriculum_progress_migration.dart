import '../../../data/models/user_model.dart';
import 'expanded_course_data.dart';

/// Migrates saved completion from the previous three-word lesson layout
/// to the current five-word layout without marking unstudied vocabulary complete.
class CurriculumProgressMigration {
  CurriculumProgressMigration._();

  static const int currentVersion = 2;
  static const int _legacyWordsPerLesson = 3;
  static const int _currentWordsPerLesson = 5;

  static UserModel migrate(UserModel user) {
    if (user.curriculumVersion >= currentVersion) return user;

    final units = ExpandedCourseData.units;
    final unitsById = {for (final unit in units) unit.id: unit};
    final coveredWordIndexes = <String, Set<int>>{};
    final completedCheckpoints = <String>{};
    final retainedIds = <String>{};

    for (final completedId in user.completedLessonIds) {
      if (completedId.startsWith('checkpoint_')) {
        final topicId = completedId.substring('checkpoint_'.length);
        if (unitsById.containsKey(topicId)) {
          completedCheckpoints.add(topicId);
        } else {
          retainedIds.add(completedId);
        }
        continue;
      }

      final match = RegExp(r'^(.+)_l([1-9]\d*)$').firstMatch(completedId);
      final topicId = match?.group(1);
      final oldLessonNumber = int.tryParse(match?.group(2) ?? '');
      if (topicId == null ||
          oldLessonNumber == null ||
          !unitsById.containsKey(topicId)) {
        retainedIds.add(completedId);
        continue;
      }

      final indexes = coveredWordIndexes.putIfAbsent(topicId, () => <int>{});
      final firstWord = (oldLessonNumber - 1) * _legacyWordsPerLesson + 1;
      final lastWord = firstWord + _legacyWordsPerLesson - 1;
      for (var wordIndex = firstWord; wordIndex <= lastWord; wordIndex++) {
        indexes.add(wordIndex);
      }
    }

    final migratedIds = <String>{...retainedIds};
    for (final unit in units) {
      final topicCoverage = coveredWordIndexes[unit.id] ?? const <int>{};
      final completedEntireTopic = completedCheckpoints.contains(unit.id);

      for (var lessonIndex = 0;
          lessonIndex < unit.lessons.length;
          lessonIndex++) {
        final firstWord =
            lessonIndex * _currentWordsPerLesson + 1;
        final fullyCovered = List<int>.generate(
          _currentWordsPerLesson,
          (offset) => firstWord + offset,
        ).every(topicCoverage.contains);

        if (completedEntireTopic || fullyCovered) {
          migratedIds.add(unit.lessons[lessonIndex].id);
        }
      }

      if (completedEntireTopic) {
        migratedIds.add('checkpoint_${unit.id}');
      }
    }

    final orderedIds = <String>[];
    for (final id in user.completedLessonIds) {
      if (retainedIds.contains(id) && !orderedIds.contains(id)) {
        orderedIds.add(id);
      }
    }
    for (final unit in units) {
      for (final lesson in unit.lessons) {
        if (migratedIds.contains(lesson.id)) orderedIds.add(lesson.id);
      }
      final checkpointId = 'checkpoint_${unit.id}';
      if (migratedIds.contains(checkpointId)) orderedIds.add(checkpointId);
    }

    return user.copyWith(
      completedLessonIds: orderedIds,
      curriculumVersion: currentVersion,
    );
  }
}
