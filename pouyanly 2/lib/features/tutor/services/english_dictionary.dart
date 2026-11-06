import '../../lessons/models/lesson_data.dart';

class DictionaryEntry {
  final String word, meaning, pronunciation, example, exampleFa;
  const DictionaryEntry(this.word, this.meaning, this.pronunciation, this.example, this.exampleFa);
}

/// Offline dictionary: course vocabulary plus a compact general-purpose core.
class EnglishDictionary {
  EnglishDictionary._();

  static const Map<String, DictionaryEntry> _extra = {
    'abandon': DictionaryEntry('abandon','رها کردن / ترک کردن','/əˈbændən/','They had to abandon the plan.','آن‌ها مجبور شدند برنامه را رها کنند.'),
    'ability': DictionaryEntry('ability','توانایی','/əˈbɪləti/','She has the ability to learn quickly.','او توانایی یادگیری سریع را دارد.'),
    'achieve': DictionaryEntry('achieve','دست یافتن / به دست آوردن','/əˈtʃiːv/','You can achieve your goal.','می‌توانی به هدفت برسی.'),
    'accurate': DictionaryEntry('accurate','دقیق','/ˈækjərət/','The information is accurate.','اطلاعات دقیق است.'),
    'actually': DictionaryEntry('actually','در واقع','/ˈæktʃuəli/','I actually enjoyed the book.','در واقع از کتاب لذت بردم.'),
    'afford': DictionaryEntry('afford','از عهدهٔ هزینه برآمدن','/əˈfɔːrd/','I cannot afford a new laptop.','از عهدهٔ خرید لپ‌تاپ جدید برنمی‌آیم.'),
    'although': DictionaryEntry('although','اگرچه','/ɔːlˈðoʊ/','Although it was late, we continued.','اگرچه دیر بود، ادامه دادیم.'),
    'analyse': DictionaryEntry('analyse','تحلیل کردن','/ˈænəlaɪz/','We need to analyse the results.','باید نتایج را تحلیل کنیم.'),
    'approach': DictionaryEntry('approach','رویکرد / نزدیک شدن','/əˈproʊtʃ/','We need a practical approach.','به یک رویکرد عملی نیاز داریم.'),
    'benefit': DictionaryEntry('benefit','فایده / سود بردن','/ˈbenɪfɪt/','Reading has many benefits.','مطالعه فواید زیادی دارد.'),
    'challenge': DictionaryEntry('challenge','چالش','/ˈtʃælɪndʒ/','Learning a language is a challenge.','یادگیری زبان یک چالش است.'),
    'choice': DictionaryEntry('choice','انتخاب','/tʃɔɪs/','It was a difficult choice.','انتخاب دشواری بود.'),
    'claim': DictionaryEntry('claim','ادعا کردن / ادعا','/kleɪm/','The article makes a strong claim.','مقاله ادعای محکمی مطرح می‌کند.'),
    'common': DictionaryEntry('common','رایج / مشترک','/ˈkɑːmən/','This is a common mistake.','این اشتباه رایجی است.'),
    'compare': DictionaryEntry('compare','مقایسه کردن','/kəmˈper/','Compare the two answers.','دو پاسخ را مقایسه کن.'),
    'concern': DictionaryEntry('concern','نگرانی / مربوط بودن','/kənˈsɜːrn/','Safety is a major concern.','ایمنی یک نگرانی مهم است.'),
    'consider': DictionaryEntry('consider','در نظر گرفتن','/kənˈsɪdər/','Please consider another option.','لطفاً گزینهٔ دیگری را در نظر بگیر.'),
    'create': DictionaryEntry('create','خلق کردن / ایجاد کردن','/kriˈeɪt/','They create useful tools.','آن‌ها ابزارهای مفیدی می‌سازند.'),
    'decision': DictionaryEntry('decision','تصمیم','/dɪˈsɪʒən/','It was an important decision.','تصمیم مهمی بود.'),
    'develop': DictionaryEntry('develop','توسعه دادن / رشد کردن','/dɪˈveləp/','We develop new skills.','مهارت‌های تازه‌ای توسعه می‌دهیم.'),
    'effective': DictionaryEntry('effective','موثر','/ɪˈfektɪv/','This is an effective method.','این روش مؤثری است.'),
    'environment': DictionaryEntry('environment','محیط زیست / محیط','/ɪnˈvaɪrənmənt/','We should protect the environment.','باید از محیط زیست محافظت کنیم.'),
    'essential': DictionaryEntry('essential','ضروری','/ɪˈsenʃəl/','Sleep is essential for health.','خواب برای سلامتی ضروری است.'),
    'experience': DictionaryEntry('experience','تجربه','/ɪkˈspɪriəns/','It was a valuable experience.','تجربهٔ ارزشمندی بود.'),
    'explain': DictionaryEntry('explain','توضیح دادن','/ɪkˈspleɪn/','Can you explain this rule?','می‌توانی این قاعده را توضیح بدهی؟'),
    'feature': DictionaryEntry('feature','ویژگی','/ˈfiːtʃər/','The app has a useful feature.','برنامه ویژگی مفیدی دارد.'),
    'frequent': DictionaryEntry('frequent','مکرر / پرتکرار','/ˈfriːkwənt/','Frequent practice helps.','تمرین مکرر کمک می‌کند.'),
    'improve': DictionaryEntry('improve','بهبود دادن','/ɪmˈpruːv/','Practice can improve your writing.','تمرین می‌تواند نوشتنت را بهتر کند.'),
    'increase': DictionaryEntry('increase','افزایش دادن / یافتن','/ɪnˈkriːs/','Prices may increase.','ممکن است قیمت‌ها افزایش یابند.'),
    'issue': DictionaryEntry('issue','موضوع / مسئله','/ˈɪʃuː/','We discussed the main issue.','دربارهٔ مسئلهٔ اصلی صحبت کردیم.'),
    'knowledge': DictionaryEntry('knowledge','دانش','/ˈnɑːlɪdʒ/','Knowledge takes time to build.','ساختن دانش زمان می‌برد.'),
    'likely': DictionaryEntry('likely','محتمل','/ˈlaɪkli/','It is likely to rain.','احتمالاً باران می‌بارد.'),
    'maintain': DictionaryEntry('maintain','حفظ کردن','/meɪnˈteɪn/','Maintain a regular routine.','یک برنامهٔ منظم را حفظ کن.'),
    'opportunity': DictionaryEntry('opportunity','فرصت','/ˌɑːpərˈtuːnəti/','This is a great opportunity.','این فرصت فوق‌العاده‌ای است.'),
    'particularly': DictionaryEntry('particularly','به‌ویژه','/pərˈtɪkjələrli/','I particularly like this example.','من به‌ویژه این مثال را دوست دارم.'),
    'probably': DictionaryEntry('probably','احتمالاً','/ˈprɑːbəbli/','She will probably come later.','او احتمالاً بعداً می‌آید.'),
    'provide': DictionaryEntry('provide','فراهم کردن / ارائه دادن','/prəˈvaɪd/','The course provides examples.','دوره مثال‌هایی ارائه می‌دهد.'),
    'purpose': DictionaryEntry('purpose','هدف','/ˈpɜːrpəs/','What is the purpose of this task?','هدف این تمرین چیست؟'),
    'require': DictionaryEntry('require','نیاز داشتن / لازم داشتن','/rɪˈkwaɪər/','The task requires patience.','این کار به صبر نیاز دارد.'),
    'research': DictionaryEntry('research','پژوهش','/ˈriːsɜːrtʃ/','The research is interesting.','این پژوهش جالب است.'),
    'result': DictionaryEntry('result','نتیجه','/rɪˈzʌlt/','The result was surprising.','نتیجه غافلگیرکننده بود.'),
    'significant': DictionaryEntry('significant','قابل توجه / مهم','/sɪɡˈnɪfɪkənt/','There was a significant change.','تغییر قابل توجهی رخ داد.'),
    'similar': DictionaryEntry('similar','مشابه','/ˈsɪmələr/','The two ideas are similar.','این دو ایده مشابه‌اند.'),
    'solution': DictionaryEntry('solution','راه‌حل','/səˈluːʃən/','We found a simple solution.','راه‌حل ساده‌ای پیدا کردیم.'),
    'suggest': DictionaryEntry('suggest','پیشنهاد دادن','/səˈdʒest/','I suggest taking a break.','پیشنهاد می‌کنم کمی استراحت کنی.'),
    'therefore': DictionaryEntry('therefore','بنابراین','/ˈðerfɔːr/','It was raining; therefore, we stayed home.','باران می‌بارید؛ بنابراین خانه ماندیم.'),
    'throughout': DictionaryEntry('throughout','در سراسر / در تمام مدت','/θruːˈaʊt/','It rained throughout the night.','تمام شب باران بارید.'),
    'valuable': DictionaryEntry('valuable','ارزشمند','/ˈvæljuəbəl/','Your time is valuable.','زمان تو ارزشمند است.'),
    'various': DictionaryEntry('various','گوناگون','/ˈveriəs/','We discussed various topics.','دربارهٔ موضوعات گوناگون صحبت کردیم.'),
    'whether': DictionaryEntry('whether','آیا / اینکه آیا','/ˈweðər/','I do not know whether he agrees.','نمی‌دانم آیا او موافق است یا نه.'),
  };

  static String _normalise(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static DictionaryEntry? find(String query) {
    final normalized = _normalise(query);
    if (normalized.isEmpty) return null;
    final courseWords = CourseData.getAllUnits()
        .expand((unit) => unit.lessons)
        .expand((lesson) => lesson.vocabulary);
    for (final item in courseWords) {
      final word = _normalise(item.english);
      if (normalized == word || normalized.contains(' $word ') ||
          normalized.startsWith('$word ') || normalized.endsWith(' $word')) {
        return DictionaryEntry(item.english, item.farsi, item.pronunciation, item.exampleEn, item.exampleFa);
      }
    }
    for (final entry in _extra.values) {
      final word = _normalise(entry.word);
      if (normalized == word || normalized.contains(' $word ') ||
          normalized.startsWith('$word ') || normalized.endsWith(' $word')) return entry;
    }
    return null;
  }

  static DictionaryEntry? findByPersian(String query) {
    final tokens = query.trim().split(RegExp(r'\s+')).where((t) => t.length > 1).toList().reversed;
    if (tokens.isEmpty) return null;
    for (final token in tokens) {
      for (final item in CourseData.getAllUnits().expand((u) => u.lessons).expand((l) => l.vocabulary)) {
        if (item.farsi.contains(token)) {
          return DictionaryEntry(item.english, item.farsi, item.pronunciation, item.exampleEn, item.exampleFa);
        }
      }
      for (final entry in _extra.values) {
        if (entry.meaning.contains(token)) return entry;
      }
    }
    return null;
  }
}
