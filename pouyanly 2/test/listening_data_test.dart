import 'package:flutter_test/flutter_test.dart';
import 'package:pouyanly/features/listening/models/listening_data.dart';

void main() {
  group('Listening practice content', () {
    test('all listening exercises have valid unique content', () {
      expect(ListeningData.validate(), isTrue);
    });

    test('practice includes beginner and elementary-plus material', () {
      expect(ListeningData.exercises.any((item) => item.level == 'A1'), isTrue);
      expect(ListeningData.exercises.any((item) => item.level == 'A2'), isTrue);
    });

    test('each exercise has a single selectable answer', () {
      for (final item in ListeningData.exercises) {
        expect(item.options.where((option) => option == item.answer).length, 1);
      }
    });
  });
}
