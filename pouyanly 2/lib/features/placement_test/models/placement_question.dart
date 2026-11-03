import '../../lessons/models/lesson_data.dart';
import '../../../data/models/user_model.dart';

class PlacementQuestion {
  final String id;
  final String skill; // vocabulary, grammar, reading
  final String cefrLevel; // A1, A2, B1, B2
  final int difficulty; // 1-6
  final String question;
  final String questionFarsi;
  final List<String> options;
  final String correctAnswer;
  final String explanationFarsi;

  const PlacementQuestion({
    required this.id,
    required this.skill,
    required this.cefrLevel,
    required this.difficulty,
    required this.question,
    required this.questionFarsi,
    required this.options,
    required this.correctAnswer,
    required this.explanationFarsi,
  });
}

class PlacementTestData {
  PlacementTestData._();

  static final List<PlacementQuestion> questions = [
    // ── A1 Vocabulary ──
    const PlacementQuestion(
      id: 'pt_1',
      skill: 'vocabulary',
      cefrLevel: 'A1',
      difficulty: 1,
      question: 'What does "Hello" mean?',
      questionFarsi: '"Hello" یعنی چه؟',
      options: ['خداحافظ', 'سلام', 'ممنون', 'ببخشید'],
      correctAnswer: 'سلام',
      explanationFarsi: '"Hello" رایج‌ترین احوال‌پرسی در زبان انگلیسی است.',
    ),
    const PlacementQuestion(
      id: 'pt_2',
      skill: 'vocabulary',
      cefrLevel: 'A1',
      difficulty: 1,
      question: 'What color is the sky?',
      questionFarsi: 'رنگ آسمان چیست؟',
      options: ['Red', 'Green', 'Blue', 'Yellow'],
      correctAnswer: 'Blue',
      explanationFarsi: 'آسمان آبی است. "Blue" به معنای آبی می‌باشد.',
    ),

    // ── A1 Grammar ──
    const PlacementQuestion(
      id: 'pt_3',
      skill: 'grammar',
      cefrLevel: 'A1',
      difficulty: 1,
      question: 'Choose the correct sentence:',
      questionFarsi: 'جمله صحیح را انتخاب کنید:',
      options: ['I am student.', 'I is a student.', 'I am a student.', 'Me am a student.'],
      correctAnswer: 'I am a student.',
      explanationFarsi: 'در جمله اسمی با "I"، فعل "am" استفاده می‌شود. قبل از اسم مفرد از "a" استفاده کنید.',
    ),

    // ── A2 Vocabulary ──
    const PlacementQuestion(
      id: 'pt_4',
      skill: 'vocabulary',
      cefrLevel: 'A2',
      difficulty: 2,
      question: 'What does "breakfast" mean?',
      questionFarsi: '"breakfast" چه معنایی دارد؟',
      options: ['ناهار', 'شام', 'صبحانه', 'میان‌وعده'],
      correctAnswer: 'صبحانه',
      explanationFarsi: '"Breakfast" اولین وعده غذایی روز است که صبح می‌خوریم.',
    ),
    const PlacementQuestion(
      id: 'pt_5',
      skill: 'vocabulary',
      cefrLevel: 'A2',
      difficulty: 2,
      question: 'Which word means "خسته"?',
      questionFarsi: 'کدام کلمه به معنای "خسته" است؟',
      options: ['Happy', 'Angry', 'Tired', 'Hungry'],
      correctAnswer: 'Tired',
      explanationFarsi: '"Tired" به معنای خسته است. مثال: "I am tired after a long day."',
    ),

    // ── A2 Grammar ──
    const PlacementQuestion(
      id: 'pt_6',
      skill: 'grammar',
      cefrLevel: 'A2',
      difficulty: 2,
      question: 'She ___ to school every day.',
      questionFarsi: 'او هر روز به مدرسه ___ می‌رود.',
      options: ['go', 'goes', 'going', 'gone'],
      correctAnswer: 'goes',
      explanationFarsi: 'با ضمیر سوم شخص مفرد (She/He/It) در زمان حال ساده، به فعل "s" اضافه می‌کنیم.',
    ),

    // ── B1 Vocabulary ──
    const PlacementQuestion(
      id: 'pt_7',
      skill: 'vocabulary',
      cefrLevel: 'B1',
      difficulty: 3,
      question: 'What does "ambitious" mean?',
      questionFarsi: '"ambitious" چه معنایی دارد؟',
      options: ['تنبل', 'بلندپرواز / جاه‌طلب', 'آرام', 'خجالتی'],
      correctAnswer: 'بلندپرواز / جاه‌طلب',
      explanationFarsi: '"Ambitious" یعنی کسی که اهداف بزرگ دارد و برای رسیدن به آنها تلاش می‌کند.',
    ),
    const PlacementQuestion(
      id: 'pt_8',
      skill: 'vocabulary',
      cefrLevel: 'B1',
      difficulty: 3,
      question: 'Choose the word that means "حل کردن مشکل":',
      questionFarsi: 'کلمه‌ای که معنای "حل کردن مشکل" را دارد انتخاب کنید:',
      options: ['Create', 'Avoid', 'Solve', 'Ignore'],
      correctAnswer: 'Solve',
      explanationFarsi: '"Solve" به معنای حل کردن است. مثال: "We need to solve this problem."',
    ),

    // ── B1 Grammar ──
    const PlacementQuestion(
      id: 'pt_9',
      skill: 'grammar',
      cefrLevel: 'B1',
      difficulty: 3,
      question: 'By the time I arrived, she ___ already left.',
      questionFarsi: 'وقتی رسیدم، او قبلاً رفته بود.',
      options: ['has', 'have', 'had', 'was'],
      correctAnswer: 'had',
      explanationFarsi: 'زمان "Past Perfect" با "had" ساخته می‌شود. برای عملی که قبل از زمان گذشته دیگری اتفاق افتاده استفاده می‌شود.',
    ),

    // ── B2 Vocabulary ──
    const PlacementQuestion(
      id: 'pt_10',
      skill: 'vocabulary',
      cefrLevel: 'B2',
      difficulty: 4,
      question: 'What does "meticulous" mean?',
      questionFarsi: '"meticulous" چه معنایی دارد؟',
      options: ['بی‌دقت', 'کنجکاو', 'دقیق و موشکاف', 'صبور'],
      correctAnswer: 'دقیق و موشکاف',
      explanationFarsi: '"Meticulous" به معنای بسیار دقیق و توجه به جزئیات است. مثال: "She is meticulous in her work."',
    ),

    // ── B2 Grammar ──
    const PlacementQuestion(
      id: 'pt_11',
      skill: 'grammar',
      cefrLevel: 'B2',
      difficulty: 4,
      question: 'If I ___ you, I would accept the offer.',
      questionFarsi: 'اگر جای تو بودم، پیشنهاد را قبول می‌کردم.',
      options: ['am', 'was', 'were', 'had been'],
      correctAnswer: 'were',
      explanationFarsi: 'در جمله شرطی نوع دوم (Conditional Type 2)، در کلوز "if" از "were" برای همه ضمایر استفاده می‌شود.',
    ),

    // ── Reading ──
    const PlacementQuestion(
      id: 'pt_12',
      skill: 'reading',
      cefrLevel: 'A2',
      difficulty: 2,
      question: 'Read: "Tom wakes up at 7 AM. He eats breakfast and then goes to work." What does Tom do first?',
      questionFarsi: 'متن: "تام ساعت ۷ بیدار می‌شود. صبحانه می‌خورد و بعد به کار می‌رود." تام اول چه کاری می‌کند؟',
      options: ['Goes to work', 'Wakes up', 'Eats breakfast', 'Comes home'],
      correctAnswer: 'Wakes up',
      explanationFarsi: 'طبق متن، تام اول "wakes up" (بیدار می‌شود) سپس صبحانه می‌خورد.',
    ),
    const PlacementQuestion(
      id: 'pt_13',
      skill: 'reading',
      cefrLevel: 'B1',
      difficulty: 3,
      question: 'Read: "Despite the heavy rain, the football match was not cancelled." What does "despite" mean here?',
      questionFarsi: '"با وجود باران شدید، مسابقه فوتبال لغو نشد." "despite" چه معنایی دارد؟',
      options: ['به دلیل', 'با وجود', 'به جای', 'درست مانند'],
      correctAnswer: 'با وجود',
      explanationFarsi: '"Despite" یعنی "با وجود" یا "علیرغم". این کلمه برای بیان تضاد به کار می‌رود.',
    ),
  ];

  // ── Calculate CEFR result from answers ───────────────────────────
  static Map<String, dynamic> calculateResult(Map<String, String> answers) {
    final Map<String, List<bool>> skillResults = {
      'vocabulary': [],
      'grammar': [],
      'reading': [],
    };

    final Map<String, List<bool>> levelResults = {
      'A1': [], 'A2': [], 'B1': [], 'B2': [],
    };

    for (final q in questions) {
      final answer = answers[q.id];
      final correct = answer == q.correctAnswer;
      skillResults[q.skill]?.add(correct);
      levelResults[q.cefrLevel]?.add(correct);
    }

    // Skill percentages
    final skillScores = <String, int>{};
    for (final entry in skillResults.entries) {
      if (entry.value.isEmpty) continue;
      final correct = entry.value.where((b) => b).length;
      skillScores[entry.key] = ((correct / entry.value.length) * 100).round();
    }

    // Level accuracy
    double a1Score = _levelScore(levelResults['A1']!);
    double a2Score = _levelScore(levelResults['A2']!);
    double b1Score = _levelScore(levelResults['B1']!);
    double b2Score = _levelScore(levelResults['B2']!);

    // Determine CEFR level
    CefrLevel cefrLevel;
    if (b2Score >= 0.7) {
      cefrLevel = CefrLevel.b2;
    } else if (b1Score >= 0.6) {
      cefrLevel = CefrLevel.b1;
    } else if (a2Score >= 0.6) {
      cefrLevel = CefrLevel.a2;
    } else {
      cefrLevel = CefrLevel.a1;
    }

    return {
      'cefrLevel': cefrLevel,
      'skillScores': skillScores,
    };
  }

  static double _levelScore(List<bool> results) {
    if (results.isEmpty) return 0.0;
    return results.where((b) => b).length / results.length;
  }
}
