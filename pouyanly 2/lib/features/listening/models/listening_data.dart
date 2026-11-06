import 'package:flutter/foundation.dart';

@immutable
class ListeningExercise {
  final String id;
  final String title;
  final String level;
  final String dialogue;
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;

  const ListeningExercise({
    required this.id,
    required this.title,
    required this.level,
    required this.dialogue,
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });
}

class ListeningData {
  ListeningData._();

  static const exercises = <ListeningExercise>[
    ListeningExercise(
      id: 'listen_a1_cafe',
      title: 'At the café',
      level: 'A1',
      dialogue: 'Hello. Can I have a cup of tea, please? Of course. Anything else? No, thank you.',
      question: 'What does the customer order?',
      options: ['A cup of tea', 'A glass of water', 'A cup of coffee', 'A sandwich'],
      answer: 'A cup of tea',
      explanation: 'مشتری یک فنجان چای سفارش می‌دهد.',
    ),
    ListeningExercise(
      id: 'listen_a1_meeting',
      title: 'Meeting a new friend',
      level: 'A1',
      dialogue: 'Hi, I am Daniel. What is your name? My name is Sara. Nice to meet you, Sara. Nice to meet you too.',
      question: 'What is the woman’s name?',
      options: ['Anna', 'Sara', 'Emma', 'Mary'],
      answer: 'Sara',
      explanation: 'او می‌گوید: My name is Sara.',
    ),
    ListeningExercise(
      id: 'listen_a1_time',
      title: 'Making plans',
      level: 'A1',
      dialogue: 'Are you free on Saturday? Yes, I am. Let us meet at ten in the morning. Great. See you then.',
      question: 'When will they meet?',
      options: ['At nine', 'At ten', 'At eleven', 'At twelve'],
      answer: 'At ten',
      explanation: 'زمان قرار، ساعت ده صبح است.',
    ),
    ListeningExercise(
      id: 'listen_a2_directions',
      title: 'Asking for directions',
      level: 'A2',
      dialogue: 'Excuse me, how can I get to the train station? Go straight ahead and turn left at the bank. The station is next to the supermarket.',
      question: 'Where should the listener turn left?',
      options: ['At the bank', 'At the school', 'At the hotel', 'At the park'],
      answer: 'At the bank',
      explanation: 'در مکالمه گفته می‌شود کنار بانک به چپ بپیچد.',
    ),
    ListeningExercise(
      id: 'listen_a2_weekend',
      title: 'Weekend plans',
      level: 'A2',
      dialogue: 'What did you do last weekend? I visited my grandparents on Saturday and watched a film with my brother on Sunday.',
      question: 'What did the speaker do on Sunday?',
      options: ['Visited grandparents', 'Played football', 'Watched a film', 'Went shopping'],
      answer: 'Watched a film',
      explanation: 'گوینده می‌گوید یکشنبه با برادرش فیلم تماشا کرده است.',
    ),
  ];

  static bool validate() {
    final ids = exercises.map((item) => item.id).toList();
    return ids.toSet().length == ids.length &&
        exercises.every((item) =>
            item.dialogue.trim().isNotEmpty &&
            item.question.trim().isNotEmpty &&
            item.options.length >= 2 &&
            item.options.toSet().length == item.options.length &&
            item.options.contains(item.answer) &&
            item.explanation.trim().isNotEmpty);
  }
}
