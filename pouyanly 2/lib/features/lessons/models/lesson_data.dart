import 'expanded_course_data.dart';

// ─── Enums ─────────────────────────────────────────────────────────────────

enum ExerciseType {
  multipleChoice,
  fillInBlank,
  matching,
  translation,
  reorder,
  listenAndChoose,
  speakAndRecord,
  trueFalse,
  imageMatch,
  sentenceBuilder,
  spellCheck,
}

// ─── Models ────────────────────────────────────────────────────────────────

class VocabularyItem {
  final String english;
  final String pronunciation;
  final String farsi;
  final String exampleEn;
  final String exampleFa;
  final String cefrLevel;
  final String category;

  const VocabularyItem({
    required this.english,
    required this.pronunciation,
    required this.farsi,
    required this.exampleEn,
    required this.exampleFa,
    required this.cefrLevel,
    required this.category,
  });
}

class Exercise {
  final String id;
  final ExerciseType type;
  final String question;
  final String questionFarsi;
  final List<String> options;
  final String correctAnswer;
  final String explanationFarsi;
  final String? exampleEn;
  final String? exampleFa;
  final int xpReward;

  const Exercise({
    required this.id,
    required this.type,
    required this.question,
    required this.questionFarsi,
    required this.options,
    required this.correctAnswer,
    required this.explanationFarsi,
    this.exampleEn,
    this.exampleFa,
    this.xpReward = 5,
  });
}

class Lesson {
  final String id;
  final String title;
  final String titleFarsi;
  final String cefrLevel;
  final List<VocabularyItem> vocabulary;
  final List<Exercise> exercises;
  final int xpReward;
  final String emoji;
  final List<String> objectivesFarsi;
  final List<String> skillFocus;
  final int estimatedMinutes;

  const Lesson({
    required this.id,
    required this.title,
    required this.titleFarsi,
    required this.cefrLevel,
    required this.vocabulary,
    required this.exercises,
    this.xpReward = 20,
    this.emoji = '📚',
    this.objectivesFarsi = const [],
    this.skillFocus = const [],
    this.estimatedMinutes = 5,
  });
}

class Unit {
  final String id;
  final String title;
  final String titleFarsi;
  final String cefrLevel;
  final String emoji;
  final List<Lesson> lessons;

  const Unit({
    required this.id,
    required this.title,
    required this.titleFarsi,
    required this.cefrLevel,
    required this.emoji,
    required this.lessons,
  });
}

/// Central pass rule shared by lesson UI and automated tests.
class LessonPassPolicy {
  LessonPassPolicy._();

  static const double minimumAccuracy = 0.70;

  static bool isPassed({required int correct, required int total}) {
    if (total <= 0 || correct < 0 || correct > total) return false;
    return correct / total >= minimumAccuracy;
  }
}

// ─── Course Data ────────────────────────────────────────────────────────────

class CourseData {
  CourseData._();

  // ── A1 Units ─────────────────────────────────────────────────────

  static final List<Unit> a1Units = [
    Unit(
      id: 'a1_u1',
      title: 'Greetings & Introductions',
      titleFarsi: 'احوال‌پرسی و معرفی',
      cefrLevel: 'A1',
      emoji: '👋',
      lessons: [
        Lesson(
          id: 'a1_u1_l1',
          title: 'Hello & Goodbye',
          titleFarsi: 'سلام و خداحافظی',
          objectivesFarsi: const ['بتوانی به انگلیسی سلام و خداحافظی کنی و خودت را با یک جمله معرفی کنی.'],
          skillFocus: const ['vocabulary', 'speaking'],
          estimatedMinutes: 6,
          cefrLevel: 'A1',
          emoji: '🙋',
          xpReward: 20,
          vocabulary: [
            const VocabularyItem(
              english: 'Hello',
              pronunciation: '/həˈloʊ/',
              farsi: 'سلام',
              exampleEn: 'Hello, my name is Ali.',
              exampleFa: 'سلام، اسم من علی است.',
              cefrLevel: 'A1',
              category: 'greetings',
            ),
            const VocabularyItem(
              english: 'Goodbye',
              pronunciation: '/ˌɡʊdˈbaɪ/',
              farsi: 'خداحافظ',
              exampleEn: 'Goodbye! See you tomorrow.',
              exampleFa: 'خداحافظ! فردا می‌بینمت.',
              cefrLevel: 'A1',
              category: 'greetings',
            ),
            const VocabularyItem(
              english: 'Thank you',
              pronunciation: '/ˈθæŋk juː/',
              farsi: 'ممنونم',
              exampleEn: 'Thank you for your help.',
              exampleFa: 'ممنون از کمکت.',
              cefrLevel: 'A1',
              category: 'greetings',
            ),
            const VocabularyItem(
              english: 'Please',
              pronunciation: '/pliːz/',
              farsi: 'لطفاً',
              exampleEn: 'Please sit down.',
              exampleFa: 'لطفاً بنشینید.',
              cefrLevel: 'A1',
              category: 'greetings',
            ),
            const VocabularyItem(
              english: 'Sorry',
              pronunciation: '/ˈsɒri/',
              farsi: 'ببخشید / متأسفم',
              exampleEn: 'Sorry, I am late.',
              exampleFa: 'ببخشید، دیر کردم.',
              cefrLevel: 'A1',
              category: 'greetings',
            ),
          ],
          exercises: [
            Exercise(
              id: 'a1_u1_l1_e1',
              type: ExerciseType.multipleChoice,
              question: 'What does "Hello" mean in Farsi?',
              questionFarsi: '"Hello" به فارسی چه معنایی دارد؟',
              options: ['خداحافظ', 'سلام', 'ممنون', 'لطفاً'],
              correctAnswer: 'سلام',
              explanationFarsi: '"Hello" یکی از رایج‌ترین کلمات احوال‌پرسی در زبان انگلیسی است. معادل فارسی آن "سلام" می‌باشد.',
              exampleEn: 'Hello, how are you?',
              exampleFa: 'سلام، حالت چطور است؟',
            ),
            Exercise(
              id: 'a1_u1_l1_e2',
              type: ExerciseType.multipleChoice,
              question: 'How do you say "خداحافظ" in English?',
              questionFarsi: '"خداحافظ" را به انگلیسی چطور می‌گویند؟',
              options: ['Hello', 'Please', 'Goodbye', 'Sorry'],
              correctAnswer: 'Goodbye',
              explanationFarsi: '"Goodbye" به معنای خداحافظ است. می‌توانید کوتاه‌تر هم بگویید: "Bye"',
              exampleEn: 'Goodbye! Have a nice day.',
              exampleFa: 'خداحافظ! روز خوبی داشته باشی.',
            ),
            Exercise(
              id: 'a1_u1_l1_e3',
              type: ExerciseType.multipleChoice,
              question: 'Fill in the blank: "___, my name is Sara."',
              questionFarsi: 'جای خالی را پر کنید: "___, اسم من ساراست."',
              options: ['Sorry', 'Goodbye', 'Please', 'Hello'],
              correctAnswer: 'Hello',
              explanationFarsi: 'وقتی می‌خواهیم خودمان را معرفی کنیم، ابتدا "Hello" می‌گوییم.',
              exampleEn: 'Hello, my name is Sara. Nice to meet you!',
              exampleFa: 'سلام، اسم من ساراست. از آشنایی‌ات خوشحالم!',
            ),
          ],
        ),
        Lesson(
          id: 'a1_u1_l2',
          title: 'How are you?',
          titleFarsi: 'حال شما چطور است؟',
          objectivesFarsi: const ['بتوانی دربارهٔ حال خودت سؤال کنی و با عبارت‌های ساده پاسخ بدهی.'],
          skillFocus: const ['vocabulary', 'speaking'],
          estimatedMinutes: 6,
          cefrLevel: 'A1',
          emoji: '😊',
          xpReward: 20,
          vocabulary: [
            const VocabularyItem(
              english: 'Good',
              pronunciation: '/ɡʊd/',
              farsi: 'خوب',
              exampleEn: 'I am good, thank you.',
              exampleFa: 'خوبم، ممنون.',
              cefrLevel: 'A1',
              category: 'feelings',
            ),
            const VocabularyItem(
              english: 'Fine',
              pronunciation: '/faɪn/',
              farsi: 'خوب / عالی',
              exampleEn: 'I\'m fine. How about you?',
              exampleFa: 'خوبم. تو چطوری؟',
              cefrLevel: 'A1',
              category: 'feelings',
            ),
            const VocabularyItem(
              english: 'Happy',
              pronunciation: '/ˈhæpi/',
              farsi: 'خوشحال',
              exampleEn: 'I am very happy today.',
              exampleFa: 'امروز خیلی خوشحالم.',
              cefrLevel: 'A1',
              category: 'feelings',
            ),
            const VocabularyItem(
              english: 'Tired',
              pronunciation: '/ˈtaɪərd/',
              farsi: 'خسته',
              exampleEn: 'I am tired after work.',
              exampleFa: 'بعد از کار خسته‌ام.',
              cefrLevel: 'A1',
              category: 'feelings',
            ),
          ],
          exercises: [
            Exercise(
              id: 'a1_u1_l2_e1',
              type: ExerciseType.multipleChoice,
              question: 'What does "Happy" mean?',
              questionFarsi: '"Happy" چه معنایی دارد؟',
              options: ['خسته', 'ناراحت', 'خوشحال', 'بیمار'],
              correctAnswer: 'خوشحال',
              explanationFarsi: '"Happy" به معنای خوشحال و شاد است. متضاد آن "Sad" به معنای ناراحت می‌باشد.',
              exampleEn: 'She looks very happy today!',
              exampleFa: 'او امروز خیلی خوشحال به نظر می‌رسد!',
            ),
            Exercise(
              id: 'a1_u1_l2_e2',
              type: ExerciseType.multipleChoice,
              question: 'A: "How are you?" B: "I am ___, thank you."',
              questionFarsi: 'جواب مناسب برای "حالت چطوره؟" چیست؟',
              options: ['Sorry', 'Goodbye', 'Fine', 'Hello'],
              correctAnswer: 'Fine',
              explanationFarsi: '"Fine" یکی از رایج‌ترین پاسخ‌ها به "How are you?" است.',
              exampleEn: 'A: How are you? B: I\'m fine, thank you.',
              exampleFa: 'الف: حالت چطوره؟ ب: خوبم، ممنون.',
            ),
          ],
        ),
      ],
    ),

    Unit(
      id: 'a1_u2',
      title: 'Numbers & Colors',
      titleFarsi: 'اعداد و رنگ‌ها',
      cefrLevel: 'A1',
      emoji: '🔢',
      lessons: [
        Lesson(
          id: 'a1_u2_l1',
          title: 'Numbers 1-10',
          titleFarsi: 'اعداد ۱ تا ۱۰',
          objectivesFarsi: const ['بتوانی اعداد پایه را تشخیص بدهی و در جمله‌های ساده به کار ببری.'],
          skillFocus: const ['vocabulary', 'reading'],
          estimatedMinutes: 6,
          cefrLevel: 'A1',
          emoji: '🔢',
          xpReward: 20,
          vocabulary: [
            const VocabularyItem(english: 'One', pronunciation: '/wʌn/', farsi: 'یک', exampleEn: 'I have one book.', exampleFa: 'من یک کتاب دارم.', cefrLevel: 'A1', category: 'numbers'),
            const VocabularyItem(english: 'Two', pronunciation: '/tuː/', farsi: 'دو', exampleEn: 'I have two sisters.', exampleFa: 'من دو خواهر دارم.', cefrLevel: 'A1', category: 'numbers'),
            const VocabularyItem(english: 'Three', pronunciation: '/θriː/', farsi: 'سه', exampleEn: 'There are three cats.', exampleFa: 'سه گربه هستند.', cefrLevel: 'A1', category: 'numbers'),
            const VocabularyItem(english: 'Four', pronunciation: '/fɔːr/', farsi: 'چهار', exampleEn: 'I have four apples.', exampleFa: 'من چهار سیب دارم.', cefrLevel: 'A1', category: 'numbers'),
            const VocabularyItem(english: 'Five', pronunciation: '/faɪv/', farsi: 'پنج', exampleEn: 'She has five fingers.', exampleFa: 'او پنج انگشت دارد.', cefrLevel: 'A1', category: 'numbers'),
          ],
          exercises: [
            Exercise(
              id: 'a1_u2_l1_e1',
              type: ExerciseType.multipleChoice,
              question: 'What is "Three" in Farsi?',
              questionFarsi: '"Three" به فارسی چه می‌شود؟',
              options: ['دو', 'چهار', 'سه', 'پنج'],
              correctAnswer: 'سه',
              explanationFarsi: '"Three" عدد ۳ است. در زبان انگلیسی اعداد را باید حفظ کنیم.',
              exampleEn: 'Three plus two equals five.',
              exampleFa: 'سه به علاوه دو مساوی پنج است.',
            ),
            Exercise(
              id: 'a1_u2_l1_e2',
              type: ExerciseType.multipleChoice,
              question: 'How do you write the number 5 in English?',
              questionFarsi: 'عدد ۵ به انگلیسی چطور نوشته می‌شود؟',
              options: ['Four', 'Six', 'Three', 'Five'],
              correctAnswer: 'Five',
              explanationFarsi: '"Five" عدد پنج است. تلفظ آن /faɪv/ می‌باشد.',
            ),
          ],
        ),
        Lesson(
          id: 'a1_u2_l2',
          title: 'Basic Colors',
          titleFarsi: 'رنگ‌های اصلی',
          objectivesFarsi: const ['بتوانی نام رنگ‌های اصلی را بفهمی و برای توصیف اشیا استفاده کنی.'],
          skillFocus: const ['vocabulary', 'speaking'],
          estimatedMinutes: 6,
          cefrLevel: 'A1',
          emoji: '🎨',
          xpReward: 20,
          vocabulary: [
            const VocabularyItem(english: 'Red', pronunciation: '/rɛd/', farsi: 'قرمز', exampleEn: 'The apple is red.', exampleFa: 'سیب قرمز است.', cefrLevel: 'A1', category: 'colors'),
            const VocabularyItem(english: 'Blue', pronunciation: '/bluː/', farsi: 'آبی', exampleEn: 'The sky is blue.', exampleFa: 'آسمان آبی است.', cefrLevel: 'A1', category: 'colors'),
            const VocabularyItem(english: 'Green', pronunciation: '/ɡriːn/', farsi: 'سبز', exampleEn: 'The grass is green.', exampleFa: 'چمن سبز است.', cefrLevel: 'A1', category: 'colors'),
            const VocabularyItem(english: 'Yellow', pronunciation: '/ˈjɛloʊ/', farsi: 'زرد', exampleEn: 'The sun is yellow.', exampleFa: 'خورشید زرد است.', cefrLevel: 'A1', category: 'colors'),
            const VocabularyItem(english: 'Black', pronunciation: '/blæk/', farsi: 'مشکی', exampleEn: 'My car is black.', exampleFa: 'ماشین من مشکی است.', cefrLevel: 'A1', category: 'colors'),
          ],
          exercises: [
            Exercise(
              id: 'a1_u2_l2_e1',
              type: ExerciseType.multipleChoice,
              question: 'The sky is ___.',
              questionFarsi: 'آسمان ___ است.',
              options: ['Red', 'Blue', 'Green', 'Yellow'],
              correctAnswer: 'Blue',
              explanationFarsi: 'رنگ آبی در انگلیسی "Blue" نام دارد. آسمان آبی رنگ است.',
              exampleEn: 'The sky is blue and beautiful today.',
              exampleFa: 'آسمان امروز آبی و زیباست.',
            ),
          ],
        ),
      ],
    ),

    Unit(
      id: 'a1_u3',
      title: 'Family',
      titleFarsi: 'خانواده',
      cefrLevel: 'A1',
      emoji: '👨‍👩‍👧‍👦',
      lessons: [
        Lesson(
          id: 'a1_u3_l1',
          title: 'Family Members',
          titleFarsi: 'اعضای خانواده',
          objectivesFarsi: const ['بتوانی اعضای خانواده را نام ببری و دربارهٔ رابطه‌های خانوادگی جملهٔ ساده بسازی.'],
          skillFocus: const ['vocabulary', 'speaking'],
          estimatedMinutes: 6,
          cefrLevel: 'A1',
          emoji: '👨‍👩‍👧',
          xpReward: 20,
          vocabulary: [
            const VocabularyItem(english: 'Mother', pronunciation: '/ˈmʌðər/', farsi: 'مادر', exampleEn: 'My mother is kind.', exampleFa: 'مادرم مهربان است.', cefrLevel: 'A1', category: 'family'),
            const VocabularyItem(english: 'Father', pronunciation: '/ˈfɑːðər/', farsi: 'پدر', exampleEn: 'My father works hard.', exampleFa: 'پدرم سخت کار می‌کند.', cefrLevel: 'A1', category: 'family'),
            const VocabularyItem(english: 'Sister', pronunciation: '/ˈsɪstər/', farsi: 'خواهر', exampleEn: 'I have one sister.', exampleFa: 'من یک خواهر دارم.', cefrLevel: 'A1', category: 'family'),
            const VocabularyItem(english: 'Brother', pronunciation: '/ˈbrʌðər/', farsi: 'برادر', exampleEn: 'My brother is tall.', exampleFa: 'برادرم بلند قد است.', cefrLevel: 'A1', category: 'family'),
            const VocabularyItem(english: 'Family', pronunciation: '/ˈfæməli/', farsi: 'خانواده', exampleEn: 'I love my family.', exampleFa: 'خانواده‌ام را دوست دارم.', cefrLevel: 'A1', category: 'family'),
          ],
          exercises: [
            Exercise(
              id: 'a1_u3_l1_e1',
              type: ExerciseType.multipleChoice,
              question: 'What does "Mother" mean?',
              questionFarsi: '"Mother" چه معنایی دارد؟',
              options: ['پدر', 'خواهر', 'مادر', 'برادر'],
              correctAnswer: 'مادر',
              explanationFarsi: '"Mother" به معنای مادر است. در زبان محاوره‌ای انگلیسی "Mom" هم گفته می‌شود.',
              exampleEn: 'My mother cooks delicious food.',
              exampleFa: 'مادرم غذای خوشمزه می‌پزد.',
            ),
            Exercise(
              id: 'a1_u3_l1_e2',
              type: ExerciseType.multipleChoice,
              question: 'Complete: "I have one ___." (برادر)',
              questionFarsi: 'جمله را کامل کنید: "I have one ___." (برادر)',
              options: ['Sister', 'Mother', 'Brother', 'Father'],
              correctAnswer: 'Brother',
              explanationFarsi: '"Brother" به معنای برادر است. در زبان محاوره‌ای "Bro" هم گفته می‌شود.',
            ),
          ],
        ),
      ],
    ),
  ];

  // ── A2 Units ─────────────────────────────────────────────────────

  static final List<Unit> a2Units = [
    Unit(
      id: 'a2_u1',
      title: 'Daily Life',
      titleFarsi: 'زندگی روزمره',
      cefrLevel: 'A2',
      emoji: '🌅',
      lessons: [
        Lesson(
          id: 'a2_u1_l1',
          title: 'Daily Routines',
          titleFarsi: 'برنامه روزانه',
          objectivesFarsi: const ['بتوانی کارهای روزمره را با فعل‌های رایج و زمان حال ساده توصیف کنی.'],
          skillFocus: const ['vocabulary', 'grammar', 'writing'],
          estimatedMinutes: 8,
          cefrLevel: 'A2',
          emoji: '⏰',
          xpReward: 25,
          vocabulary: [
            const VocabularyItem(english: 'Wake up', pronunciation: '/weɪk ʌp/', farsi: 'بیدار شدن', exampleEn: 'I wake up at 7 AM.', exampleFa: 'ساعت ۷ صبح بیدار می‌شوم.', cefrLevel: 'A2', category: 'daily'),
            const VocabularyItem(english: 'Breakfast', pronunciation: '/ˈbrɛkfəst/', farsi: 'صبحانه', exampleEn: 'I eat breakfast every morning.', exampleFa: 'هر صبح صبحانه می‌خورم.', cefrLevel: 'A2', category: 'daily'),
            const VocabularyItem(english: 'Go to work', pronunciation: '/ɡoʊ tə wɜːrk/', farsi: 'به سر کار رفتن', exampleEn: 'I go to work by bus.', exampleFa: 'با اتوبوس به سر کار می‌روم.', cefrLevel: 'A2', category: 'daily'),
            const VocabularyItem(english: 'Come home', pronunciation: '/kʌm hoʊm/', farsi: 'به خانه آمدن', exampleEn: 'I come home at 6 PM.', exampleFa: 'ساعت ۶ عصر به خانه می‌آیم.', cefrLevel: 'A2', category: 'daily'),
            const VocabularyItem(english: 'Sleep', pronunciation: '/sliːp/', farsi: 'خوابیدن', exampleEn: 'I sleep 8 hours a day.', exampleFa: 'روزی ۸ ساعت می‌خوابم.', cefrLevel: 'A2', category: 'daily'),
          ],
          exercises: [
            Exercise(
              id: 'a2_u1_l1_e1',
              type: ExerciseType.multipleChoice,
              question: 'What does "Wake up" mean?',
              questionFarsi: '"Wake up" چه معنایی دارد؟',
              options: ['خوابیدن', 'بیدار شدن', 'صبحانه خوردن', 'رفتن'],
              correctAnswer: 'بیدار شدن',
              explanationFarsi: '"Wake up" یعنی از خواب بیدار شدن. مثال: "I wake up early every day."',
              exampleEn: 'I wake up at 6 AM every morning.',
              exampleFa: 'هر صبح ساعت ۶ بیدار می‌شوم.',
            ),
          ],
        ),
      ],
    ),
    Unit(
      id: 'a2_u2',
      title: 'Food & Shopping',
      titleFarsi: 'غذا و خرید',
      cefrLevel: 'A2',
      emoji: '🛒',
      lessons: [
        Lesson(
          id: 'a2_u2_l1',
          title: 'At the Restaurant',
          titleFarsi: 'در رستوران',
          objectivesFarsi: const ['بتوانی در رستوران منو بخواهی، غذا سفارش بدهی و صورت‌حساب درخواست کنی.'],
          skillFocus: const ['vocabulary', 'functional_language', 'speaking'],
          estimatedMinutes: 8,
          cefrLevel: 'A2',
          emoji: '🍽️',
          xpReward: 25,
          vocabulary: [
            const VocabularyItem(english: 'Menu', pronunciation: '/ˈmɛnjuː/', farsi: 'منو / فهرست غذا', exampleEn: 'Can I see the menu, please?', exampleFa: 'می‌توانم منو را ببینم؟', cefrLevel: 'A2', category: 'food'),
            const VocabularyItem(english: 'Waiter', pronunciation: '/ˈweɪtər/', farsi: 'گارسون / پیشخدمت', exampleEn: 'The waiter brought our food.', exampleFa: 'گارسون غذایمان را آورد.', cefrLevel: 'A2', category: 'food'),
            const VocabularyItem(english: 'Order', pronunciation: '/ˈɔːrdər/', farsi: 'سفارش دادن', exampleEn: 'I\'d like to order a pizza.', exampleFa: 'می‌خواهم پیتزا سفارش بدهم.', cefrLevel: 'A2', category: 'food'),
            const VocabularyItem(english: 'Bill', pronunciation: '/bɪl/', farsi: 'صورتحساب', exampleEn: 'Can we have the bill, please?', exampleFa: 'می‌توانیم صورتحساب را بگیریم؟', cefrLevel: 'A2', category: 'food'),
          ],
          exercises: [
            Exercise(
              id: 'a2_u2_l1_e1',
              type: ExerciseType.multipleChoice,
              question: 'You want to see the food list at a restaurant. You ask for the ___.',
              questionFarsi: 'می‌خواهید فهرست غذاها را در رستوران ببینید. چه چیزی می‌خواهید؟',
              options: ['Waiter', 'Bill', 'Menu', 'Order'],
              correctAnswer: 'Menu',
              explanationFarsi: '"Menu" لیست غذاهای رستوران است. وقتی وارد رستوران می‌شوید می‌گویید: "Can I see the menu please?"',
              exampleEn: 'Excuse me, can I see the menu, please?',
              exampleFa: 'ببخشید، می‌توانم منو را ببینم؟',
            ),
          ],
        ),
      ],
    ),
  ];

  // ── Helpers ──────────────────────────────────────────────────────

  static List<Unit> getUnitsForLevel(String cefrLevel) {
    final level = cefrLevel.toUpperCase();
    return getAllUnits().where((unit) => unit.cefrLevel == level).toList();
  }

  static List<Unit> getAllUnits() {
    final units = <Unit>[...a1Units, ...a2Units, ...ExpandedCourseData.units];
    const order = {'A1': 0, 'A2': 1, 'B1': 2, 'B2': 3, 'C1': 4, 'C2': 5};
    units.sort((a, b) => (order[a.cefrLevel] ?? 99).compareTo(order[b.cefrLevel] ?? 99));
    return units;
  }

  static Lesson? getLessonById(String id) {
    for (final unit in getAllUnits()) {
      for (final lesson in unit.lessons) {
        if (lesson.id == id) return lesson;
      }
    }
    return null;
  }
}
