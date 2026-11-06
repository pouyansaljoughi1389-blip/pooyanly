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

  // Extended high-frequency vocabulary for academic, travel, work and daily English.
  static const Map<String, DictionaryEntry> _expanded = {
    'accomplish': DictionaryEntry('accomplish','به انجام رساندن','/əˈkɑːmplɪʃ/','She accomplished her goal.','او به هدفش رسید.'),
    'adapt': DictionaryEntry('adapt','سازگار شدن / تطبیق دادن','/əˈdæpt/','You can adapt to a new environment.','می‌توانی با محیط جدید سازگار شوی.'),
    'adequate': DictionaryEntry('adequate','کافی و مناسب','/ˈædɪkwət/','We have adequate time.','زمان کافی داریم.'),
    'admission': DictionaryEntry('admission','پذیرش / ورود','/ədˈmɪʃən/','She received university admission.','او از دانشگاه پذیرش گرفت.'),
    'advice': DictionaryEntry('advice','توصیه / نصیحت','/ədˈvaɪs/','Thank you for your advice.','از توصیه‌ات ممنونم.'),
    'affect': DictionaryEntry('affect','تأثیر گذاشتن بر','/əˈfekt/','Weather can affect our plans.','آب‌وهوا می‌تواند بر برنامه‌هایمان تأثیر بگذارد.'),
    'alternative': DictionaryEntry('alternative','جایگزین / گزینهٔ دیگر','/ɔːlˈtɜːrnətɪv/','We need an alternative plan.','به یک برنامهٔ جایگزین نیاز داریم.'),
    'analysis': DictionaryEntry('analysis','تحلیل / بررسی','/əˈnæləsɪs/','The analysis took two hours.','تحلیل دو ساعت طول کشید.'),
    'annual': DictionaryEntry('annual','سالانه','/ˈænjuəl/','The annual meeting is in June.','جلسهٔ سالانه در ماه ژوئن است.'),
    'anxious': DictionaryEntry('anxious','مضطرب / نگران','/ˈæŋkʃəs/','I feel anxious before exams.','قبل از امتحان‌ها مضطرب می‌شوم.'),
    'apparent': DictionaryEntry('apparent','آشکار / ظاهری','/əˈpærənt/','The difference is apparent.','تفاوت آشکار است.'),
    'application': DictionaryEntry('application','درخواست / کاربرد / برنامه','/ˌæplɪˈkeɪʃən/','I sent my university application.','درخواست دانشگاه را فرستادم.'),
    'appreciate': DictionaryEntry('appreciate','قدردانی کردن / ارزش دانستن','/əˈpriːʃieɪt/','I appreciate your help.','از کمکت قدردانی می‌کنم.'),
    'approximately': DictionaryEntry('approximately','تقریباً / حدوداً','/əˈprɑːksɪmətli/','It takes approximately ten minutes.','حدود ده دقیقه طول می‌کشد.'),
    'argument': DictionaryEntry('argument','استدلال / بحث','/ˈɑːrɡjumənt/','Her argument is convincing.','استدلال او قانع‌کننده است.'),
    'assess': DictionaryEntry('assess','ارزیابی کردن','/əˈses/','Teachers assess students fairly.','معلمان دانش‌آموزان را منصفانه ارزیابی می‌کنند.'),
    'assumption': DictionaryEntry('assumption','فرض / پیش‌فرض','/əˈsʌmpʃən/','That assumption may be wrong.','آن فرض ممکن است اشتباه باشد.'),
    'available': DictionaryEntry('available','در دسترس / موجود','/əˈveɪləbəl/','Is this room available?','آیا این اتاق خالی است؟'),
    'aware': DictionaryEntry('aware','آگاه / مطلع','/əˈwer/','Are you aware of the change?','از این تغییر اطلاع داری؟'),
    'background': DictionaryEntry('background','پیشینه / پس‌زمینه','/ˈbækɡraʊnd/','She has a background in science.','او در علوم پیشینه دارد.'),
    'barrier': DictionaryEntry('barrier','مانع','/ˈbæriər/','Language can be a barrier.','زبان می‌تواند یک مانع باشد.'),
    'behaviour': DictionaryEntry('behaviour','رفتار','/bɪˈheɪvjər/','Good behaviour matters.','رفتار خوب اهمیت دارد.'),
    'circumstance': DictionaryEntry('circumstance','شرایط / اوضاع','/ˈsɜːrkəmstæns/','The circumstances have changed.','شرایط تغییر کرده‌اند.'),
    'colleague': DictionaryEntry('colleague','همکار','/ˈkɑːliːɡ/','My colleague helped me.','همکارم به من کمک کرد.'),
    'commitment': DictionaryEntry('commitment','تعهد / پایبندی','/kəˈmɪtmənt/','Learning requires commitment.','یادگیری به تعهد نیاز دارد.'),
    'community': DictionaryEntry('community','جامعه / اجتماع','/kəˈmjuːnəti/','The community supports the project.','جامعه از پروژه حمایت می‌کند.'),
    'consequence': DictionaryEntry('consequence','پیامد / نتیجه','/ˈkɑːnsɪkwens/','Every choice has a consequence.','هر انتخابی پیامدی دارد.'),
    'consistent': DictionaryEntry('consistent','باثبات / منظم','/kənˈsɪstənt/','Consistent practice is useful.','تمرین منظم مفید است.'),
    'contribute': DictionaryEntry('contribute','مشارکت کردن / کمک کردن','/kənˈtrɪbjuːt/','Everyone can contribute ideas.','همه می‌توانند ایده‌هایی مطرح کنند.'),
    'convenient': DictionaryEntry('convenient','راحت / مناسب','/kənˈviːniənt/','Is tomorrow convenient for you?','آیا فردا برایت مناسب است؟'),
    'cooperate': DictionaryEntry('cooperate','همکاری کردن','/koʊˈɑːpəreɪt/','The teams cooperate well.','تیم‌ها به‌خوبی همکاری می‌کنند.'),
    'cope': DictionaryEntry('cope','کنار آمدن / از پس چیزی برآمدن','/koʊp/','She learned to cope with stress.','او یاد گرفت با استرس کنار بیاید.'),
    'crucial': DictionaryEntry('crucial','بسیار مهم / حیاتی','/ˈkruːʃəl/','Sleep is crucial for learning.','خواب برای یادگیری بسیار مهم است.'),
    'decline': DictionaryEntry('decline','کاهش یافتن / رد کردن','/dɪˈklaɪn/','Sales began to decline.','فروش شروع به کاهش کرد.'),
    'demonstrate': DictionaryEntry('demonstrate','نشان دادن / اثبات کردن','/ˈdemənstreɪt/','The results demonstrate progress.','نتایج پیشرفت را نشان می‌دهند.'),
    'derive': DictionaryEntry('derive','استخراج کردن / ناشی شدن','/dɪˈraɪv/','The word derives from Latin.','این واژه از لاتین ریشه گرفته است.'),
    'distinguish': DictionaryEntry('distinguish','تمایز قائل شدن / تشخیص دادن','/dɪˈstɪŋɡwɪʃ/','Can you distinguish the sounds?','می‌توانی صداها را از هم تشخیص بدهی؟'),
    'diverse': DictionaryEntry('diverse','متنوع / گوناگون','/daɪˈvɜːrs/','The city has a diverse population.','جمعیت شهر متنوع است.'),
    'efficient': DictionaryEntry('efficient','کارآمد / پربازده','/ɪˈfɪʃənt/','This is an efficient method.','این روش کارآمدی است.'),
    'emphasise': DictionaryEntry('emphasise','تأکید کردن','/ˈemfəsaɪz/','The teacher emphasised practice.','معلم بر تمرین تأکید کرد.'),
    'enable': DictionaryEntry('enable','قادر ساختن / امکان دادن','/ɪˈneɪbəl/','Technology enables remote learning.','فناوری امکان یادگیری از راه دور را فراهم می‌کند.'),
    'encounter': DictionaryEntry('encounter','مواجه شدن / برخورد کردن','/ɪnˈkaʊntər/','We encountered a problem.','با یک مشکل روبه‌رو شدیم.'),
    'enhance': DictionaryEntry('enhance','ارتقا دادن / بهبود بخشیدن','/ɪnˈhæns/','Reading can enhance vocabulary.','مطالعه می‌تواند دایرهٔ واژگان را گسترش دهد.'),
    'establish': DictionaryEntry('establish','ایجاد کردن / تأسیس کردن','/ɪˈstæblɪʃ/','They established a new company.','آن‌ها شرکت جدیدی تأسیس کردند.'),
    'evaluate': DictionaryEntry('evaluate','ارزیابی کردن','/ɪˈvæljueɪt/','We evaluate the results.','نتایج را ارزیابی می‌کنیم.'),
    'evidence': DictionaryEntry('evidence','مدرک / شواهد','/ˈevɪdəns/','There is no clear evidence.','شواهد روشنی وجود ندارد.'),
    'expand': DictionaryEntry('expand','گسترش دادن / توسعه یافتن','/ɪkˈspænd/','The course will expand next year.','دوره سال آینده گسترش خواهد یافت.'),
    'flexible': DictionaryEntry('flexible','انعطاف‌پذیر','/ˈfleksəbəl/','We need a flexible schedule.','به یک برنامهٔ منعطف نیاز داریم.'),
    'former': DictionaryEntry('former','قبلی / سابق','/ˈfɔːrmər/','He is a former student.','او دانش‌آموز سابق است.'),
    'fundamental': DictionaryEntry('fundamental','بنیادی / اساسی','/ˌfʌndəˈmentəl/','Grammar is fundamental to writing.','گرامر برای نوشتن بنیادی است.'),
    'identify': DictionaryEntry('identify','شناسایی کردن','/aɪˈdentɪfaɪ/','Identify the main idea.','ایدهٔ اصلی را شناسایی کن.'),
    'impact': DictionaryEntry('impact','تأثیر / اثر گذاشتن','/ˈɪmpækt/','Education has a lasting impact.','آموزش تأثیری ماندگار دارد.'),
    'indicate': DictionaryEntry('indicate','نشان دادن / حاکی بودن','/ˈɪndɪkeɪt/','The sign indicates the exit.','تابلو خروجی را نشان می‌دهد.'),
    'interpret': DictionaryEntry('interpret','تفسیر کردن / برداشت کردن','/ɪnˈtɜːrprɪt/','How do you interpret this sentence?','این جمله را چگونه تفسیر می‌کنی؟'),
    'issue': DictionaryEntry('issue','موضوع / مسئله','/ˈɪʃuː/','We discussed the main issue.','دربارهٔ مسئلهٔ اصلی صحبت کردیم.'),
    'justify': DictionaryEntry('justify','توجیه کردن / دلیل آوردن','/ˈdʒʌstɪfaɪ/','Can you justify your answer?','می‌توانی برای پاسخت دلیل بیاوری؟'),
    'obtain': DictionaryEntry('obtain','به دست آوردن','/əbˈteɪn/','You can obtain more information online.','می‌توانی اطلاعات بیشتری را آنلاین به دست بیاوری.'),
    'occur': DictionaryEntry('occur','رخ دادن / اتفاق افتادن','/əˈkɜːr/','The event occurs every year.','این رویداد هر سال رخ می‌دهد.'),
    'participate': DictionaryEntry('participate','شرکت کردن / مشارکت داشتن','/pɑːrˈtɪsɪpeɪt/','Students participate in discussions.','دانش‌آموزان در بحث‌ها شرکت می‌کنند.'),
    'perceive': DictionaryEntry('perceive','درک کردن / دریافتن','/pərˈsiːv/','People perceive the world differently.','مردم جهان را به شکل‌های متفاوتی درک می‌کنند.'),
    'previous': DictionaryEntry('previous','قبلی / پیشین','/ˈpriːviəs/','Read the previous chapter.','فصل قبلی را بخوان.'),
    'relevant': DictionaryEntry('relevant','مرتبط / مربوط','/ˈreləvənt/','Please provide relevant details.','لطفاً جزئیات مرتبط را ارائه کن.'),
    'reliable': DictionaryEntry('reliable','قابل اعتماد','/rɪˈlaɪəbəl/','Use a reliable source.','از منبع قابل اعتماد استفاده کن.'),
    'retain': DictionaryEntry('retain','حفظ کردن / نگه داشتن','/rɪˈteɪn/','Review helps you retain new words.','مرور کمک می‌کند واژه‌های جدید را حفظ کنی.'),
    'reveal': DictionaryEntry('reveal','آشکار کردن / فاش کردن','/rɪˈviːl/','The study reveals a clear pattern.','این مطالعه الگویی روشن را آشکار می‌کند.'),
    'shift': DictionaryEntry('shift','تغییر / جابه‌جایی','/ʃɪft/','There was a shift in opinion.','تغییری در دیدگاه رخ داد.'),
    'specific': DictionaryEntry('specific','مشخص / معین','/spəˈsɪfɪk/','Give me a specific example.','یک مثال مشخص به من بده.'),
    'sufficient': DictionaryEntry('sufficient','کافی','/səˈfɪʃənt/','We have sufficient evidence.','شواهد کافی داریم.'),
    'tend': DictionaryEntry('tend','تمایل داشتن / معمولاً کاری کردن','/tend/','I tend to study at night.','معمولاً شب‌ها درس می‌خوانم.'),
    'valid': DictionaryEntry('valid','معتبر / قابل قبول','/ˈvælɪd/','That is a valid point.','این نکته قابل قبولی است.'),
    'widespread': DictionaryEntry('widespread','گسترده / فراگیر','/ˈwaɪdspred/','The problem is widespread.','این مشکل گسترده است.'),
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
    for (final entry in _expanded.values) {
      final word = _normalise(entry.word);
      if (normalized == word || normalized.contains(' $word ') || normalized.startsWith('$word ') || normalized.endsWith(' $word')) return entry;
    }
    return null;
  }

  /// Returns all known dictionary words found in an English phrase, in source order.
  static List<DictionaryEntry> findAll(String query) {
    final matches = RegExp(r"[A-Za-z]+(?:['-][A-Za-z]+)*").allMatches(query);
    final results = <DictionaryEntry>[];
    final seen = <String>{};
    for (final match in matches) {
      final token = match.group(0)!;
      final entry = find(token);
      if (entry != null && seen.add(_normalise(entry.word))) results.add(entry);
    }
    return results;
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
      for (final entry in _expanded.values) {
        if (entry.meaning.contains(token)) return entry;
      }
    }
    return null;
  }
}
