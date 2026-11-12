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
}