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

    // ── Extended B2, C1 and C2 screening ──
    const PlacementQuestion(
      id: 'pt_14', skill: 'grammar', cefrLevel: 'B2', difficulty: 4,
      question: 'Rarely ___ such a convincing explanation.',
      questionFarsi: 'کدام گزینه ساختار وارونهٔ درست را کامل می‌کند؟',
      options: ['I have heard', 'have I heard', 'I heard', 'heard I'],
      correctAnswer: 'have I heard',
      explanationFarsi: 'پس از قید منفی Rarely در ابتدای جمله، وارونگی فعل کمکی و فاعل رخ می‌دهد.',
    ),
    const PlacementQuestion(
      id: 'pt_15', skill: 'reading', cefrLevel: 'B2', difficulty: 4,
      question: 'The proposal was viable, albeit costly. What does albeit mean?',
      questionFarsi: 'در جمله، albeit چه معنایی دارد؟',
      options: ['زیرا', 'اگرچه', 'بنابراین', 'مگر اینکه'],
      correctAnswer: 'اگرچه',
      explanationFarsi: 'Albeit معادل رسمی although است و معنی «اگرچه» می‌دهد.',
    ),
    const PlacementQuestion(
      id: 'pt_16', skill: 'vocabulary', cefrLevel: 'C1', difficulty: 5,
      question: 'Which word means “to make something less severe”?',
      questionFarsi: 'کدام واژه به معنی «از شدت چیزی کاستن» است؟',
      options: ['Exacerbate', 'Mitigate', 'Disregard', 'Constitute'],
      correctAnswer: 'Mitigate',
      explanationFarsi: 'Mitigate یعنی شدت یا اثر منفی چیزی را کاهش دادن.',
    ),
    const PlacementQuestion(
      id: 'pt_17', skill: 'grammar', cefrLevel: 'C1', difficulty: 5,
      question: 'Had I known about the delay, I ___ earlier.',
      questionFarsi: 'جملهٔ شرطی وارونه را کامل کنید.',
      options: ['would leave', 'will have left', 'would have left', 'had left'],
      correctAnswer: 'would have left',
      explanationFarsi: 'در شرطی نوع سوم وارونه، Had + subject + past participle با would have + past participle می‌آید.',
    ),
    const PlacementQuestion(
      id: 'pt_18', skill: 'reading', cefrLevel: 'C1', difficulty: 5,
      question: 'The findings are tentative and should not be extrapolated. What is the warning?',
      questionFarsi: 'مفهوم جمله چیست؟',
      options: ['نتایج قطعی‌اند', 'نباید نتیجه را فراتر از داده‌ها تعمیم داد', 'پژوهش تکرار شده', 'داده‌ای وجود ندارد'],
      correctAnswer: 'نباید نتیجه را فراتر از داده‌ها تعمیم داد',
      explanationFarsi: 'Tentative یعنی موقت و محتاطانه؛ extrapolate یعنی برون‌یابی یا تعمیم فراتر از داده‌های موجود.',
    ),
    const PlacementQuestion(
      id: 'pt_19', skill: 'vocabulary', cefrLevel: 'C2', difficulty: 6,
      question: 'A “perfunctory” response is best described as:',
      questionFarsi: 'پاسخ perfunctory چه ویژگی‌ای دارد؟',
      options: ['دقیق و موشکافانه', 'سرسری و از روی رفع تکلیف', 'صمیمانه و طولانی', 'مبهم و شاعرانه'],
      correctAnswer: 'سرسری و از روی رفع تکلیف',
      explanationFarsi: 'Perfunctory برای کاری به کار می‌رود که بدون توجه و صرفاً برای انجام وظیفه انجام شده است.',
    ),
    const PlacementQuestion(
      id: 'pt_20', skill: 'grammar', cefrLevel: 'C2', difficulty: 6,
      question: 'No sooner ___ the announcement than the audience applauded.',
      questionFarsi: 'ساختار وارونهٔ No sooner را کامل کنید.',
      options: ['had she made', 'she had made', 'did she made', 'has she make'],
      correctAnswer: 'had she made',
      explanationFarsi: 'ساختار No sooner ... than با وارونگی و Past Perfect ساخته می‌شود.',
    ),
    const PlacementQuestion(
      id: 'pt_21', skill: 'reading', cefrLevel: 'C2', difficulty: 6,
      question: 'His account was equivocal, leaving the central issue unresolved. What does equivocal imply?',
      questionFarsi: 'equivocal در این جمله چه معنایی دارد؟',
      options: ['کاملاً روشن', 'دوپهلو و قابل تفسیر به چند شکل', 'مستند و قطعی', 'نامرتبط'],
      correctAnswer: 'دوپهلو و قابل تفسیر به چند شکل',
      explanationFarsi: 'Equivocal یعنی مبهم یا دوپهلو؛ به‌گونه‌ای که یک برداشت قطعی ارائه نمی‌کند.',
    ),

  ];

  // ── Calculate a conservative, skill-aware placement result ─────────
  // Unanswered questions are excluded rather than counted as incorrect.
  // A learner must demonstrate the prerequisite level before a higher
  // level can be recommended.
  static Map<String, dynamic> calculateResult(Map<String, String> answers) {
    final skillResults = <String, List<bool>>{
      'vocabulary': [],
      'grammar': [],
      'reading': [],
    };
    final levelResults = <String, List<bool>>{
      'A1': [], 'A2': [], 'B1': [], 'B2': [], 'C1': [], 'C2': [],
    };

    for (final q in questions) {
      final answer = answers[q.id];
      if (answer == null) continue;
      final correct = answer == q.correctAnswer;
      skillResults[q.skill]?.add(correct);
      levelResults[q.cefrLevel]?.add(correct);
    }

    final skillScores = <String, int>{};
    for (final entry in skillResults.entries) {
      if (entry.value.isEmpty) continue;
      final correct = entry.value.where((value) => value).length;
      skillScores[entry.key] = (correct * 100 / entry.value.length).round();
    }

    final levelScores = <String, double>{
      for (final entry in levelResults.entries)
        entry.key: _levelScore(entry.value),
    };

    // No submitted answers means no defensible level estimate.
    if (answers.isEmpty) {
      return {
        'cefrLevel': CefrLevel.unknown,
        'skillScores': skillScores,
        'levelScores': levelScores,
        'answeredCount': 0,
        'totalCount': questions.length,
      };
    }

    // The current question bank is a short screening tool, not a certified
    // CEFR exam. Use conservative progression and never skip prerequisites.
    var estimatedLevel = CefrLevel.a1;
    if (levelScores['A1']! >= 0.67) {
      estimatedLevel = CefrLevel.a1;
      if (levelScores['A2']! >= 0.60) {
        estimatedLevel = CefrLevel.a2;
        if (levelScores['B1']! >= 0.60) {
          estimatedLevel = CefrLevel.b1;
          if (levelScores['B2']! >= 0.60) {
            estimatedLevel = CefrLevel.b2;
            if (levelScores['C1']! >= 0.60) {
              estimatedLevel = CefrLevel.c1;
              if (levelScores['C2']! >= 0.60) {
                estimatedLevel = CefrLevel.c2;
              }
            }
          }
        }
      }
    }

    return {
      'cefrLevel': estimatedLevel,
      'skillScores': skillScores,
      'levelScores': levelScores,
      'answeredCount': answers.length,
      'totalCount': questions.length,
    };
  }

  static double _levelScore(List<bool> results) {
    if (results.isEmpty) return 0.0;
    return results.where((b) => b).length / results.length;
  }
}
