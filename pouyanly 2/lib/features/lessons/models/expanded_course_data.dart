import 'dart:math' as math;

import 'lesson_data.dart';

/// Expanded, offline CEFR curriculum. Each topic now contains six sequential lessons;
/// lesson IDs are stable so saved progress survives app updates.
class ExpandedCourseData {
  ExpandedCourseData._();

  static final List<Unit> units = _topics.map(_buildUnit).toList();

  static Unit _buildUnit(_Topic topic) {
    final lessons = <Lesson>[];
    for (var i = 0; i < 6; i++) {
      final words = List.generate(6, (index) => topic.words[(i * 2 + index) % topic.words.length]);
      final vocabulary = words.map((word) => VocabularyItem(
        english: word.en,
        pronunciation: word.ipa,
        farsi: word.fa,
        exampleEn: word.example,
        exampleFa: word.exampleFa,
        cefrLevel: topic.level,
        category: topic.id,
      )).toList();
      final meanings = words.map((word) => word.fa).toList();
      final exercises = <Exercise>[];
      for (var j = 0; j < words.length; j++) {
        final word = words[j];
        final options = <String>{word.fa, ...meanings.where((m) => m != word.fa), 'نمی‌دانم'}.toList();
        final optionSeed = topic.id.codeUnits.fold<int>(i + j, (sum, unit) => sum + unit);
        options.shuffle(math.Random(optionSeed));
        exercises.add(Exercise(
          id: '${topic.id}_l${i + 1}_e${j + 1}',
          type: ExerciseType.multipleChoice,
          question: 'What does "${word.en}" mean?',
          questionFarsi: 'معنی «${word.en}» کدام است؟',
          options: options,
          correctAnswer: word.fa,
          explanationFarsi: '«${word.en}» یعنی «${word.fa}». نمونه: ${word.example} — ${word.exampleFa}',
          exampleEn: word.example,
          exampleFa: word.exampleFa,
          xpReward: 5,
        ));
      }
      lessons.add(Lesson(
        id: '${topic.id}_l${i + 1}',
        title: topic.lessonTitles[i % topic.lessonTitles.length],
        titleFarsi: topic.lessonTitlesFa[i % topic.lessonTitlesFa.length],
        cefrLevel: topic.level,
        vocabulary: vocabulary,
        exercises: exercises,
        xpReward: topic.level == 'B2' || topic.level == 'C1' || topic.level == 'C2' ? 35 : 25,
        emoji: topic.lessonEmojis[i % topic.lessonEmojis.length],
        objectivesFarsi: [topic.objectives[i % topic.objectives.length]],
        skillFocus: const ['vocabulary', 'reading', 'sentence building'],
        estimatedMinutes: topic.level == 'A1' || topic.level == 'A2' ? 8 : 12,
      ));
    }
    return Unit(
      id: topic.id,
      title: topic.title,
      titleFarsi: topic.titleFa,
      cefrLevel: topic.level,
      emoji: topic.emoji,
      lessons: lessons,
    );
  }
}

class _Topic {
  final String id, level, title, titleFa, emoji;
  final List<String> lessonTitles, lessonTitlesFa, lessonEmojis, objectives;
  final List<_Word> words;
  const _Topic(this.id, this.level, this.title, this.titleFa, this.emoji,
      this.lessonTitles, this.lessonTitlesFa, this.lessonEmojis, this.objectives, this.words);
}

class _Word {
  final String en, fa, ipa, example, exampleFa;
  const _Word(this.en, this.fa, this.ipa, this.example, this.exampleFa);
}

const _topics = <_Topic>[
  _Topic('a1_greetings', 'A1', 'Everyday communication', 'ارتباطات روزمره', '👋',
    ['Meeting people', 'Polite expressions', 'Personal details'], ['آشنایی با افراد', 'عبارت‌های مؤدبانه', 'اطلاعات شخصی'], ['👋','🤝','🪪'],
    ['بتوانی خودت و دیگران را معرفی کنی.','در موقعیت‌های ساده مؤدبانه صحبت کنی.','اطلاعات شخصی پایه را بپرسی و پاسخ بدهی.'],
    [_Word('Nice to meet you','از آشنایی خوشوقتم','/naɪs tə miːt juː/','Nice to meet you, Sara.','از آشنایی با تو خوشوقتم، سارا.'),_Word('First name','نام کوچک','/fɜːrst neɪm/','My first name is Reza.','نام کوچک من رضاست.'),_Word('Last name','نام خانوادگی','/læst neɪm/','What is your last name?','نام خانوادگی تو چیست؟'),_Word('Please','لطفاً','/pliːz/','Please speak slowly.','لطفاً آهسته صحبت کن.'),_Word('Excuse me','ببخشید','/ɪkˈskjuːz miː/','Excuse me, where is the bank?','ببخشید، بانک کجاست؟'),_Word('You are welcome','خواهش می‌کنم','/jʊr ˈwelkəm/','You are welcome!','خواهش می‌کنم!'),_Word('Address','نشانی','/əˈdres/','What is your address?','نشانی تو چیست؟'),_Word('Country','کشور','/ˈkʌntri/','Which country are you from?','اهل کدام کشور هستی؟'),_Word('Nationality','ملیت','/ˌnæʃəˈnæləti/','What is your nationality?','ملیت تو چیست؟')]),
  _Topic('a1_home', 'A1', 'Home & family', 'خانه و خانواده', '🏡',
    ['Rooms and furniture','Family members','Describing a home'], ['اتاق‌ها و وسایل خانه','اعضای خانواده','توصیف خانه'], ['🛋️','👨‍👩‍👧','🏠'],
    ['اتاق‌ها و وسایل خانه را نام ببری.','دربارهٔ خانواده صحبت کنی.','خانه و محل زندگی‌ات را توصیف کنی.'],
    [_Word('Kitchen','آشپزخانه','/ˈkɪtʃən/','The kitchen is small.','آشپزخانه کوچک است.'),_Word('Bedroom','اتاق خواب','/ˈbedruːm/','My bedroom has a desk.','اتاق خوابم یک میز دارد.'),_Word('Living room','اتاق نشیمن','/ˈlɪvɪŋ ruːm/','We watch TV in the living room.','ما در اتاق نشیمن تلویزیون تماشا می‌کنیم.'),_Word('Parents','والدین','/ˈperənts/','My parents live nearby.','والدینم نزدیک اینجا زندگی می‌کنند.'),_Word('Cousin','پسرعمو، دخترعمو و...','/ˈkʌzən/','My cousin is a student.','پسرعمویم دانش‌آموز است.'),_Word('Grandparents','پدربزرگ و مادربزرگ','/ˈɡrænperənts/','I visit my grandparents.','به دیدن پدربزرگ و مادربزرگم می‌روم.'),_Word('Comfortable','راحت','/ˈkʌmftəbəl/','This sofa is comfortable.','این مبل راحت است.'),_Word('Upstairs','طبقهٔ بالا','/ˌʌpˈsterz/','My room is upstairs.','اتاق من طبقهٔ بالاست.'),_Word('Neighbourhood','محله','/ˈneɪbərhʊd/','Our neighbourhood is quiet.','محلهٔ ما آرام است.')]),
  _Topic('a1_food', 'A1', 'Food & everyday shopping', 'غذا و خرید روزانه', '🍎',
    ['Food and drinks','At the supermarket','Prices and quantities'], ['خوراکی‌ها و نوشیدنی‌ها','در فروشگاه','قیمت و مقدار'], ['🍓','🛒','💳'],
    ['خوراکی‌ها و نوشیدنی‌های ساده را بشناسی.','در فروشگاه کالای موردنیاز را پیدا کنی.','قیمت و مقدار را بپرسی.'],
    [_Word('Vegetables','سبزیجات','/ˈvedʒtəbəlz/','We eat vegetables every day.','ما هر روز سبزیجات می‌خوریم.'),_Word('Cheese','پنیر','/tʃiːz/','I would like some cheese.','کمی پنیر می‌خواهم.'),_Word('Bottle','بطری','/ˈbɑːtəl/','A bottle of water, please.','یک بطری آب لطفاً.'),_Word('Shopping list','فهرست خرید','/ˈʃɑːpɪŋ lɪst/','I wrote a shopping list.','فهرست خرید نوشتم.'),_Word('Cheap','ارزان','/tʃiːp/','These apples are cheap.','این سیب‌ها ارزان‌اند.'),_Word('Expensive','گران','/ɪkˈspensɪv/','That jacket is expensive.','آن کاپشن گران است.'),_Word('A kilo of','یک کیلو از','/ə ˈkiːloʊ əv/','A kilo of oranges, please.','یک کیلو پرتقال لطفاً.'),_Word('Change','باقی‌پول','/tʃeɪndʒ/','Keep the change.','باقی‌پول را نگه دار.'),_Word('Receipt','رسید','/rɪˈsiːt/','Can I have the receipt?','می‌توانم رسید را بگیرم؟')]),
  _Topic('a1_city', 'A1', 'Places & directions', 'مکان‌ها و مسیرها', '🗺️',
    ['Places in town','Asking the way','Transport basics'], ['مکان‌های شهر','آدرس پرسیدن','حمل‌ونقل پایه'], ['🏙️','🧭','🚌'],
    ['مکان‌های عمومی شهر را بشناسی.','مسیر ساده را بپرسی و توضیح بدهی.','دربارهٔ رفت‌وآمد صحبت کنی.'],
    [_Word('Library','کتابخانه','/ˈlaɪbreri/','The library is near the park.','کتابخانه نزدیک پارک است.'),_Word('Hospital','بیمارستان','/ˈhɑːspɪtəl/','The hospital is on this street.','بیمارستان در این خیابان است.'),_Word('Museum','موزه','/mjuˈziːəm/','We visited the museum.','از موزه دیدن کردیم.'),_Word('Turn left','به چپ بپیچ','/tɜːrn left/','Turn left at the corner.','سرِ پیچ به چپ بپیچ.'),_Word('Straight ahead','مستقیم جلو','/streɪt əˈhed/','Go straight ahead.','مستقیم برو.'),_Word('Across from','روبروی','/əˈkrɔːs frəm/','The café is across from the bank.','کافه روبروی بانک است.'),_Word('Bus stop','ایستگاه اتوبوس','/ˈbʌs stɑːp/','The bus stop is outside.','ایستگاه اتوبوس بیرون است.'),_Word('Ticket','بلیت','/ˈtɪkɪt/','I need a train ticket.','به بلیت قطار نیاز دارم.'),_Word('Journey','سفر','/ˈdʒɜːrni/','The journey takes an hour.','سفر یک ساعت طول می‌کشد.')]),
  _Topic('a2_health', 'A2', 'Health & wellbeing', 'سلامت و تندرستی', '🩺',
    ['Common symptoms','At the pharmacy','Healthy habits'], ['علائم رایج','در داروخانه','عادت‌های سالم'], ['🤒','🧴','🌿'],
    ['علائم ساده را توصیف کنی.','در داروخانه درخواست روشنی داشته باشی.','دربارهٔ عادت‌های سالم حرف بزنی.'],
    [_Word('Headache','سردرد','/ˈhedeɪk/','I have a headache.','سردرد دارم.'),_Word('Sore throat','گلودرد','/sɔːr θroʊt/','She has a sore throat.','او گلودرد دارد.'),_Word('Cough','سرفه','/kɔːf/','His cough is getting better.','سرفه‌اش بهتر می‌شود.'),_Word('Prescription','نسخهٔ پزشک','/prɪˈskrɪpʃən/','The pharmacist checked my prescription.','داروساز نسخه‌ام را بررسی کرد.'),_Word('Dosage','مقدار مصرف','/ˈdoʊsɪdʒ/','Read the dosage instructions.','دستور مقدار مصرف را بخوان.'),_Word('Side effect','عارضهٔ جانبی','/ˈsaɪd ɪfekt/','Ask about possible side effects.','دربارهٔ عوارض احتمالی سؤال کن.'),_Word('Balanced diet','رژیم غذایی متعادل','/ˈbælənst ˈdaɪət/','A balanced diet is important.','تغذیهٔ متعادل مهم است.'),_Word('Regular exercise','ورزش منظم','/ˈreɡjələr ˈeksərsaɪz/','Regular exercise supports health.','ورزش منظم به سلامت کمک می‌کند.'),_Word('Recover','بهبود یافتن','/rɪˈkʌvər/','It takes time to recover.','بهبود یافتن زمان می‌برد.')]),
  _Topic('a2_travel', 'A2', 'Travel & accommodation', 'سفر و اقامت', '🧳',
    ['Booking a room','At the airport','Travel problems'], ['رزرو اتاق','در فرودگاه','مشکلات سفر'], ['🏨','✈️','🧭'],
    ['اتاق رزرو کنی و امکانات را بپرسی.','در فرودگاه اطلاعات ضروری را بفهمی.','مشکلات سادهٔ سفر را توضیح بدهی.'],
    [_Word('Reservation','رزرو','/ˌrezərˈveɪʃən/','I have a reservation.','من رزرو دارم.'),_Word('Available','در دسترس / خالی','/əˈveɪləbəl/','Is a double room available?','آیا اتاق دونفره خالی دارید؟'),_Word('Accommodation','محل اقامت','/əˌkɑːməˈdeɪʃən/','We need cheap accommodation.','به محل اقامت ارزان نیاز داریم.'),_Word('Boarding pass','کارت پرواز','/ˈbɔːrdɪŋ pæs/','Show your boarding pass.','کارت پروازت را نشان بده.'),_Word('Departure','حرکت / عزیمت','/dɪˈpɑːrtʃər/','The departure is at noon.','حرکت ساعت ظهر است.'),_Word('Luggage','چمدان و بار','/ˈlʌɡɪdʒ/','My luggage is heavy.','بار من سنگین است.'),_Word('Delayed','با تأخیر','/dɪˈleɪd/','The flight is delayed.','پرواز تأخیر دارد.'),_Word('Lost property','اشیای گمشده','/ˌlɔːst ˈprɑːpərti/','Ask at lost property.','از بخش اشیای گمشده بپرس.'),_Word('Sightseeing','بازدید از جاذبه‌ها','/ˈsaɪtsiːɪŋ/','We went sightseeing.','برای دیدن جاذبه‌ها رفتیم.')]),
  _Topic('a2_work', 'A2', 'Work & study', 'کار و تحصیل', '📚',
    ['Jobs and workplaces','School and university','Plans and schedules'], ['شغل‌ها و محل کار','مدرسه و دانشگاه','برنامه و زمان‌بندی'], ['💼','🎓','🗓️'],
    ['دربارهٔ شغل‌ها و محل کار صحبت کنی.','محیط آموزشی را توصیف کنی.','برنامه‌ها و زمان‌های آینده را بیان کنی.'],
    [_Word('Colleague','همکار','/ˈkɑːliːɡ/','My colleague is helpful.','همکارم کمک‌کننده است.'),_Word('Salary','حقوق','/ˈsæləri/','The salary is paid monthly.','حقوق ماهانه پرداخت می‌شود.'),_Word('Interview','مصاحبه','/ˈɪntərvjuː/','I have a job interview.','مصاحبهٔ کاری دارم.'),_Word('Assignment','تکلیف','/əˈsaɪnmənt/','I finished the assignment.','تکلیف را تمام کردم.'),_Word('Deadline','مهلت نهایی','/ˈdedlaɪn/','The deadline is Friday.','مهلت نهایی جمعه است.'),_Word('Lecture','سخنرانی / کلاس دانشگاه','/ˈlektʃər/','The lecture starts at nine.','کلاس ساعت نه شروع می‌شود.'),_Word('Schedule','برنامهٔ زمانی','/ˈskedʒuːl/','My schedule is busy.','برنامه‌ام شلوغ است.'),_Word('Improve','بهبود دادن','/ɪmˈpruːv/','I want to improve my English.','می‌خواهم انگلیسی‌ام را بهتر کنم.'),_Word('Apply for','درخواست دادن برای','/əˈplaɪ fɔːr/','She will apply for the course.','او برای دوره درخواست می‌دهد.')]),
  _Topic('a2_weather', 'A2', 'Weather & nature', 'آب‌وهوا و طبیعت', '🌦️',
    ['Weather conditions','Seasons and climate','Outdoor activities'], ['شرایط آب‌وهوا','فصل‌ها و اقلیم','فعالیت در فضای باز'], ['🌧️','🍂','🏕️'],
    ['آب‌وهوا را توصیف کنی.','دربارهٔ فصل‌ها و تغییرات اقلیمی صحبت کنی.','فعالیت‌های بیرونی را پیشنهاد بدهی.'],
    [_Word('Cloudy','ابری','/ˈklaʊdi/','It will be cloudy tomorrow.','فردا هوا ابری خواهد بود.'),_Word('Storm','طوفان','/stɔːrm/','A storm is coming.','طوفان در راه است.'),_Word('Temperature','دما','/ˈtemprətʃər/','The temperature is rising.','دما در حال افزایش است.'),_Word('Mild','ملایم','/maɪld/','The winter is mild here.','زمستان اینجا ملایم است.'),_Word('Season','فصل','/ˈsiːzən/','Autumn is my favourite season.','پاییز فصل موردعلاقهٔ من است.'),_Word('Drought','خشکسالی','/draʊt/','The region suffered a drought.','منطقه دچار خشکسالی شد.'),_Word('Hiking','پیاده‌روی در طبیعت','/ˈhaɪkɪŋ/','We go hiking at weekends.','آخر هفته‌ها به طبیعت‌گردی می‌رویم.'),_Word('Campfire','آتش اردو','/ˈkæmpfaɪər/','We sat around the campfire.','دور آتش اردو نشستیم.'),_Word('Wildlife','حیات وحش','/ˈwaɪldlaɪf/','The park protects wildlife.','این پارک از حیات وحش محافظت می‌کند.')]),
  _Topic('b1_communication', 'B1', 'Communication & relationships', 'ارتباطات و روابط', '💬',
    ['Keeping in touch','Resolving disagreements','Personality and behaviour'], ['در تماس ماندن','حل اختلاف','شخصیت و رفتار'], ['📱','🤝','🧠'],
    ['راه‌های حفظ ارتباط را توضیح بدهی.','اختلاف‌نظر را محترمانه حل کنی.','ویژگی‌های شخصیتی را دقیق‌تر توصیف کنی.'],
    [_Word('Keep in touch','در تماس ماندن','/kiːp ɪn tʌtʃ/','We keep in touch by email.','ما از طریق ایمیل در تماس می‌مانیم.'),_Word('Misunderstanding','سوءتفاهم','/ˌmɪsʌndərˈstændɪŋ/','It was a simple misunderstanding.','این فقط یک سوءتفاهم ساده بود.'),_Word('Supportive','حامی و پشتیبان','/səˈpɔːrtɪv/','She is very supportive.','او بسیار حامی است.'),_Word('Compromise','سازش / توافق میانه','/ˈkɑːmprəmaɪz/','Both sides reached a compromise.','هر دو طرف به توافق میانه رسیدند.'),_Word('Apologise','عذرخواهی کردن','/əˈpɑːlədʒaɪz/','He apologised for being late.','او بابت دیرکرد عذرخواهی کرد.'),_Word('Considerate','باملاحظه','/kənˈsɪdərət/','That was considerate of you.','این کار از تو باملاحظه بود.'),_Word('Reliable','قابل اعتماد','/rɪˈlaɪəbəl/','She is a reliable friend.','او دوست قابل اعتمادی است.'),_Word('Boundary','مرز شخصی','/ˈbaʊndəri/','Respect other people’s boundaries.','به مرزهای دیگران احترام بگذار.'),_Word('Empathy','همدلی','/ˈempəθi/','Empathy helps us understand others.','همدلی کمک می‌کند دیگران را بفهمیم.')]),
  _Topic('b1_media', 'B1', 'Media & technology', 'رسانه و فناوری', '💻',
    ['Online communication','News and information','Digital habits'], ['ارتباط آنلاین','خبر و اطلاعات','عادت‌های دیجیتال'], ['🌐','📰','📲'],
    ['دربارهٔ ابزارهای آنلاین صحبت کنی.','خبر را از نظر منبع و اعتبار بررسی کنی.','عادت‌های دیجیتال را تحلیل کنی.'],
    [_Word('Privacy settings','تنظیمات حریم خصوصی','/ˈpraɪvəsi ˈsetɪŋz/','Check your privacy settings.','تنظیمات حریم خصوصی‌ات را بررسی کن.'),_Word('Attachment','پیوست','/əˈtætʃmənt/','I sent the file as an attachment.','فایل را به‌صورت پیوست فرستادم.'),_Word('Reliable source','منبع معتبر','/rɪˈlaɪəbəl sɔːrs/','Use a reliable source.','از منبع معتبر استفاده کن.'),_Word('Headline','تیتر خبر','/ˈhedlaɪn/','The headline was misleading.','تیتر گمراه‌کننده بود.'),_Word('Bias','سوگیری','/ˈbaɪəs/','We should recognise media bias.','باید سوگیری رسانه را بشناسیم.'),_Word('Broadcast','پخش کردن','/ˈbrɔːdkæst/','The interview was broadcast live.','مصاحبه زنده پخش شد.'),_Word('Screen time','مدت استفاده از صفحه‌نمایش','/ˈskriːn taɪm/','I try to limit my screen time.','سعی می‌کنم زمان استفاده از صفحه را محدود کنم.'),_Word('Distraction','عامل حواس‌پرتی','/dɪˈstrækʃən/','Notifications can be a distraction.','اعلان‌ها می‌توانند عامل حواس‌پرتی باشند.'),_Word('Cybersecurity','امنیت سایبری','/ˌsaɪbərsɪˈkjʊrəti/','Cybersecurity matters to everyone.','امنیت سایبری برای همه مهم است.')]),
  _Topic('b1_environment', 'B1', 'Environment & society', 'محیط زیست و جامعه', '🌱',
    ['Environmental challenges','Community projects','Sustainable choices'], ['چالش‌های زیست‌محیطی','پروژه‌های اجتماعی','انتخاب‌های پایدار'], ['🌍','🏘️','♻️'],
    ['دربارهٔ مسائل محیط‌زیستی استدلال کنی.','یک پروژهٔ اجتماعی را معرفی کنی.','انتخاب‌های پایدار را مقایسه کنی.'],
    [_Word('Renewable energy','انرژی تجدیدپذیر','/rɪˈnuːəbəl ˈenərdʒi/','Solar power is renewable energy.','انرژی خورشیدی تجدیدپذیر است.'),_Word('Waste','زباله / هدررفت','/weɪst/','We should reduce waste.','باید زباله را کاهش دهیم.'),_Word('Conservation','حفاظت','/ˌkɑːnsərˈveɪʃən/','Conservation protects nature.','حفاظت از طبیعت مراقبت می‌کند.'),_Word('Volunteer','داوطلب شدن','/ˌvɑːlənˈtɪr/','I volunteer at a local centre.','در یک مرکز محلی داوطلب هستم.'),_Word('Fundraising','جمع‌آوری کمک مالی','/ˈfʌndˌreɪzɪŋ/','The group organised fundraising.','گروه برنامهٔ جمع‌آوری کمک مالی برگزار کرد.'),_Word('Neighbourhood project','پروژهٔ محله','/ˈneɪbərhʊd ˈprɑːdʒekt/','The neighbourhood project improved the park.','پروژهٔ محله پارک را بهتر کرد.'),_Word('Carbon footprint','ردپای کربن','/ˈkɑːrbən ˈfʊtprɪnt/','Cycling reduces your carbon footprint.','دوچرخه‌سواری ردپای کربن را کم می‌کند.'),_Word('Reusable','قابل استفادهٔ مجدد','/riːˈjuːzəbəl/','Take a reusable bottle.','یک بطری چندبارمصرف بردار.'),_Word('Consequence','پیامد','/ˈkɑːnsɪkwens/','Every choice has a consequence.','هر انتخابی پیامدی دارد.')]),
  _Topic('b1_work', 'B1', 'Workplace skills', 'مهارت‌های محیط کار', '🧑‍💼',
    ['Teamwork','Problem-solving','Professional communication'], ['کار تیمی','حل مسئله','ارتباط حرفه‌ای'], ['👥','🧩','📧'],
    ['در جلسه مشارکت کنی و نظر بدهی.','راه‌حل‌های یک مشکل را پیشنهاد بدهی.','ایمیل حرفه‌ای بنویسی.'],
    [_Word('Collaborate','همکاری کردن','/kəˈlæbəreɪt/','We collaborate on the project.','روی پروژه با هم همکاری می‌کنیم.'),_Word('Contribute','مشارکت کردن','/kənˈtrɪbjuːt/','Everyone can contribute ideas.','همه می‌توانند ایده بدهند.'),_Word('Deadline','ضرب‌الاجل','/ˈdedlaɪn/','We must meet the deadline.','باید به ضرب‌الاجل برسیم.'),_Word('Approach','رویکرد','/əˈproʊtʃ/','Let’s try a different approach.','بیایید رویکرد دیگری را امتحان کنیم.'),_Word('Evaluate','ارزیابی کردن','/ɪˈvæljueɪt/','We need to evaluate the results.','باید نتایج را ارزیابی کنیم.'),_Word('Priority','اولویت','/praɪˈɔːrəti/','Safety is our first priority.','ایمنی اولویت اول ماست.'),_Word('Clarify','شفاف‌سازی کردن','/ˈklærəfaɪ/','Could you clarify the request?','ممکن است درخواست را روشن‌تر کنید؟'),_Word('Regarding','در رابطه با','/rɪˈɡɑːrdɪŋ/','I am writing regarding your email.','در رابطه با ایمیلتان می‌نویسم.'),_Word('Feedback','بازخورد','/ˈfiːdbæk/','Thank you for your feedback.','از بازخوردتان ممنونم.')]),
  _Topic('b2_argument', 'B2', 'Argumentation & critical thinking', 'استدلال و تفکر نقادانه', '🧠',
    ['Building an argument','Evaluating evidence','Counterarguments'], ['ساختن استدلال','ارزیابی شواهد','استدلال مخالف'], ['🗣️','🔎','⚖️'],
    ['موضعی روشن و مستدل بیان کنی.','اعتبار شواهد را ارزیابی کنی.','به دیدگاه مخالف پاسخ منطقی بدهی.'],
    [_Word('Compelling','قانع‌کننده','/kəmˈpelɪŋ/','She made a compelling argument.','او استدلالی قانع‌کننده مطرح کرد.'),_Word('Substantiate','مستند کردن','/səbˈstænʃieɪt/','The claim is difficult to substantiate.','مستند کردن این ادعا دشوار است.'),_Word('Premise','مقدمهٔ استدلال','/ˈpremɪs/','The argument rests on a false premise.','استدلال بر مقدمه‌ای نادرست تکیه دارد.'),_Word('Counterargument','استدلال مخالف','/ˈkaʊntərˌɑːrɡjumənt/','Consider the strongest counterargument.','قوی‌ترین استدلال مخالف را در نظر بگیر.'),_Word('Evidence','شواهد','/ˈevɪdəns/','The evidence supports the conclusion.','شواهد از نتیجه پشتیبانی می‌کنند.'),_Word('Assumption','فرض','/əˈsʌmpʃən/','That assumption needs testing.','آن فرض باید آزموده شود.'),_Word('Nuance','ظرافت معنایی','/ˈnuːɑːns/','The issue requires nuance.','این مسئله به ظرافت نیاز دارد.'),_Word('Concede','پذیرفتن بخشی از نظر','/kənˈsiːd/','I concede that point.','آن نکته را می‌پذیرم.'),_Word('Rebuttal','پاسخ ردکننده','/rɪˈbʌtəl/','Her rebuttal was precise.','پاسخ ردکنندهٔ او دقیق بود.')]),
  _Topic('b2_academic', 'B2', 'Academic English', 'انگلیسی دانشگاهی', '🎓',
    ['Academic writing','Research methods','Presenting findings'], ['نگارش دانشگاهی','روش پژوهش','ارائهٔ یافته‌ها'], ['✍️','📑','📊'],
    ['متن دانشگاهی منسجم بنویسی.','روش و محدودیت پژوهش را توضیح بدهی.','یافته‌ها را دقیق ارائه کنی.'],
    [_Word('Furthermore','علاوه بر این','/ˌfɜːrðərˈmɔːr/','Furthermore, the results were consistent.','علاوه بر این، نتایج سازگار بودند.'),_Word('Whereas','درحالی‌که','/werˈæz/','Costs rose, whereas quality declined.','هزینه‌ها بالا رفت، درحالی‌که کیفیت افت کرد.'),_Word('Nevertheless','بااین‌حال','/ˌnevərðəˈles/','Nevertheless, the study has value.','بااین‌حال، پژوهش ارزشمند است.'),_Word('Methodology','روش‌شناسی','/ˌmeθəˈdɑːlədʒi/','The methodology is clearly explained.','روش‌شناسی به‌روشنی توضیح داده شده است.'),_Word('Sample size','حجم نمونه','/ˈsæmpəl saɪz/','The sample size was limited.','حجم نمونه محدود بود.'),_Word('Limitation','محدودیت','/ˌlɪmɪˈteɪʃən/','The paper acknowledges its limitations.','مقاله محدودیت‌های خود را می‌پذیرد.'),_Word('Findings','یافته‌ها','/ˈfaɪndɪŋz/','The findings are presented below.','یافته‌ها در ادامه ارائه شده‌اند.'),_Word('Correlate','همبستگی داشتن','/ˈkɔːrəleɪt/','The two variables correlate.','این دو متغیر همبستگی دارند.'),_Word('Implication','پیامد / دلالت','/ˌɪmplɪˈkeɪʃən/','The implications are significant.','دلالت‌های آن مهم‌اند.')]),
  _Topic('b2_fluency', 'B2', 'Fluency & idiomatic language', 'روانی و زبان اصطلاحی', '🎙️',
    ['Hedging and emphasis','Idioms in context','Register and tone'], ['بیان محتاطانه و تأکید','اصطلاح در بافت','سطح رسمیت و لحن'], ['🗣️','💡','🎭'],
    ['نظر را با میزان قطعیت مناسب بیان کنی.','اصطلاح‌ها را در بافت درست به کار ببری.','لحن رسمی و غیررسمی را تشخیص بدهی.'],
    [_Word('To some extent','تا حدی','/tə sʌm ɪkˈstent/','I agree to some extent.','تا حدی موافقم.'),_Word('Arguably','به‌جرئت می‌توان گفت','/ˈɑːrɡjuəbli/','Arguably, this is the best option.','به‌جرئت می‌توان گفت این بهترین گزینه است.'),_Word('Inevitably','ناگزیر','/ɪnˈevɪtəbli/','Change inevitably takes time.','تغییر ناگزیر زمان می‌برد.'),_Word('Break the ice','یخ جمع را شکستن','/breɪk ði aɪs/','A joke helped break the ice.','یک شوخی به گرم شدن جمع کمک کرد.'),_Word('Get the hang of','قِلِق چیزی را یاد گرفتن','/ɡet ðə hæŋ əv/','You will get the hang of it.','قِلِقش را یاد می‌گیری.'),_Word('On the same page','هم‌نظر و هماهنگ','/ɑːn ðə seɪm peɪdʒ/','Let’s make sure we are on the same page.','مطمئن شویم برداشت یکسانی داریم.'),_Word('Formal register','لحن رسمی','/ˈfɔːrməl ˈredʒɪstər/','Use a formal register in the report.','در گزارش از لحن رسمی استفاده کن.'),_Word('Colloquial','محاوره‌ای','/kəˈloʊkwiəl/','This phrase is colloquial.','این عبارت محاوره‌ای است.'),_Word('Understatement','کم‌گویی عمدی','/ˌʌndərˈsteɪtmənt/','That is an understatement.','این کم‌گویی است.')]),
  _Topic('b2_global', 'B2', 'Global issues & policy', 'مسائل جهانی و سیاست‌گذاری', '🌐',
    ['Economic change','Public policy','Global cooperation'], ['تحول اقتصادی','سیاست عمومی','همکاری جهانی'], ['📈','🏛️','🤝'],
    ['روندهای اقتصادی را تحلیل کنی.','دربارهٔ سیاست عمومی نظر بدهی.','همکاری بین‌المللی را توصیف کنی.'],
    [_Word('Inequality','نابرابری','/ˌɪnɪˈkwɑːləti/','The policy aims to reduce inequality.','این سیاست قصد دارد نابرابری را کاهش دهد.'),_Word('Inflation','تورم','/ɪnˈfleɪʃən/','Inflation affects household budgets.','تورم بر بودجهٔ خانوار اثر می‌گذارد.'),_Word('Incentive','مشوق','/ɪnˈsentɪv/','Tax incentives encourage investment.','مشوق‌های مالیاتی سرمایه‌گذاری را تشویق می‌کنند.'),_Word('Regulation','مقررات','/ˌreɡjuˈleɪʃən/','The industry needs clear regulation.','این صنعت به مقررات روشن نیاز دارد.'),_Word('Implementation','اجرا','/ˌɪmplɪmenˈteɪʃən/','Implementation may take years.','اجرای آن ممکن است سال‌ها طول بکشد.'),_Word('Stakeholder','ذی‌نفع','/ˈsteɪkhoʊldər/','Every stakeholder should be consulted.','باید با هر ذی‌نفع مشورت شود.'),_Word('Diplomacy','دیپلماسی','/dɪˈploʊməsi/','Diplomacy can prevent conflict.','دیپلماسی می‌تواند از درگیری جلوگیری کند.'),_Word('Consensus','اجماع','/kənˈsensəs/','The group reached a consensus.','گروه به اجماع رسید.'),_Word('Trade-off','موازنهٔ بده‌بستان','/ˈtreɪd ɔːf/','Every option involves a trade-off.','هر گزینه‌ای بده‌بستانی دارد.')]),
  _Topic('c1_rhetoric', 'C1', 'Rhetoric & persuasive discourse', 'بلاغت و گفتمان اقناعی', '🎤',
    ['Persuasive techniques','Rhetorical structure','Subtle disagreement'], ['فن‌های اقناع','ساختار بلاغی','مخالفت ظریف'], ['📣','🧱','🪶'],
    ['فن‌های اقناع را تحلیل کنی.','گفتمان منسجم و اثرگذار بسازی.','مخالفت ظریف و حرفه‌ای بیان کنی.'],
    [_Word('Plausible','باورپذیر','/ˈplɔːzəbəl/','It is a plausible explanation.','این توضیح باورپذیر است.'),_Word('Meticulous','بسیار دقیق','/məˈtɪkjələs/','The report is meticulous.','گزارش بسیار دقیق است.'),_Word('Eloquent','فصیح و شیوا','/ˈeləkwənt/','She gave an eloquent speech.','او سخنرانی شیوا ارائه کرد.'),_Word('Convoluted','پیچیده و درهم','/ˈkɑːnvəluːtɪd/','The explanation is convoluted.','توضیح پیچیده و درهم است.'),_Word('Undermine','تضعیف کردن','/ˌʌndərˈmaɪn/','This may undermine trust.','این ممکن است اعتماد را تضعیف کند.'),_Word('Conspicuous','آشکار و جلب‌توجه‌کننده','/kənˈspɪkjuəs/','There was a conspicuous omission.','یک حذف آشکار وجود داشت.'),_Word('Granted','البته / پذیرفته که','/ˈɡræntɪd/','Granted, the plan is ambitious.','البته برنامه بلندپروازانه است.'),_Word('I take your point','منظورت را می‌فهمم','/aɪ teɪk jʊr pɔɪnt/','I take your point, but disagree.','منظورت را می‌فهمم، اما مخالفم.'),_Word('That said','بااین‌حال','/ðæt sed/','That said, we need more data.','بااین‌حال، به دادهٔ بیشتری نیاز داریم.')]),
  _Topic('c1_research', 'C1', 'Research & advanced analysis', 'پژوهش و تحلیل پیشرفته', '🔬',
    ['Interpreting data','Research critique','Cautious conclusions'], ['تفسیر داده','نقد پژوهش','نتیجه‌گیری محتاطانه'], ['📊','🧪','🧭'],
    ['داده‌های پیچیده را تفسیر کنی.','روش و استدلال پژوهش را نقد کنی.','نتیجه‌گیری دقیق و محتاطانه بنویسی.'],
    [_Word('Discrepancy','ناهمخوانی','/dɪˈskrepənsi/','There is a discrepancy in the data.','در داده‌ها ناهمخوانی وجود دارد.'),_Word('Robust','مستحکم و قابل اتکا','/roʊˈbʌst/','The study uses robust methods.','پژوهش از روش‌های قابل اتکا استفاده می‌کند.'),_Word('Infer','استنباط کردن','/ɪnˈfɜːr/','We can infer a pattern.','می‌توانیم الگویی استنباط کنیم.'),_Word('Corroborate','تأیید و تقویت کردن','/kəˈrɑːbəreɪt/','Other studies corroborate the finding.','پژوهش‌های دیگر این یافته را تأیید می‌کنند.'),_Word('Confounding variable','متغیر مخدوش‌گر','/kənˈfaʊndɪŋ ˈveriəbəl/','Control the confounding variables.','متغیرهای مخدوش‌گر را کنترل کن.'),_Word('Longitudinal','طولی / در گذر زمان','/ˌlɑːndʒɪˈtuːdɪnəl/','It was a longitudinal study.','این یک مطالعهٔ طولی بود.'),_Word('Tentative','موقت و محتاطانه','/ˈtentətɪv/','The conclusion remains tentative.','نتیجه‌گیری همچنان موقت است.'),_Word('Extrapolate','برون‌یابی کردن','/ɪkˈstræpəleɪt/','Do not extrapolate beyond the sample.','فراتر از نمونه برون‌یابی نکن.'),_Word('Caveat','قید و ملاحظه','/ˈkæviæt/','There is one important caveat.','یک ملاحظهٔ مهم وجود دارد.')]),
  _Topic('c1_professional', 'C1', 'Professional nuance', 'ظرافت زبان حرفه‌ای', '🧑‍💻',
    ['Negotiation','Diplomatic language','Complex decisions'], ['مذاکره','زبان دیپلماتیک','تصمیم‌های پیچیده'], ['🤝','🕊️','♟️'],
    ['در مذاکره پیشنهاد و امتیازدهی کنی.','با زبان دیپلماتیک مخالفت کنی.','تصمیم پیچیده را با ظرافت توضیح بدهی.'],
    [_Word('Feasible','امکان‌پذیر','/ˈfiːzəbəl/','The proposal is feasible.','پیشنهاد امکان‌پذیر است.'),_Word('Mutually beneficial','دارای منفعت دوطرفه','/ˈmjuːtʃuəli ˌbenɪˈfɪʃəl/','We seek a mutually beneficial deal.','به‌دنبال توافقی با منفعت دوطرفه هستیم.'),_Word('Concession','امتیاز / کوتاه‌آمدن','/kənˈseʃən/','Both parties made a concession.','هر دو طرف امتیازی دادند.'),_Word('With all due respect','با کمال احترام','/wɪð ɔːl duː rɪˈspekt/','With all due respect, I disagree.','با کمال احترام، مخالفم.'),_Word('I would question whether','جای سؤال دارد که آیا','/aɪ wʊd ˈkwestʃən ˈweðər/','I would question whether it is necessary.','جای سؤال دارد که آیا ضروری است.'),_Word('Viable','عملی و شدنی','/ˈvaɪəbəl/','We need a viable alternative.','به یک جایگزین عملی نیاز داریم.'),_Word('Preliminary','مقدماتی','/prɪˈlɪməneri/','These are preliminary results.','این‌ها نتایج مقدماتی‌اند.'),_Word('Adverse','نامطلوب','/ædˈvɜːrs/','The change had adverse effects.','این تغییر اثرات نامطلوبی داشت.'),_Word('Mitigate','کاهش دادن شدت','/ˈmɪtɪɡeɪt/','The plan may mitigate risk.','این برنامه ممکن است ریسک را کاهش دهد.')]),
  _Topic('c2_expression', 'C2', 'Precision & stylistic mastery', 'دقت و تسلط سبکی', '🪶',
    ['Fine shades of meaning','Register shifts','Concise precision'], ['تفاوت‌های ظریف معنا','تغییر سطح زبان','دقت و ایجاز'], ['🎨','🎭','✒️'],
    ['تفاوت‌های ظریف واژگان را تشخیص بدهی.','سبک را متناسب با مخاطب تغییر بدهی.','مطلب پیچیده را موجز و دقیق بیان کنی.'],
    [_Word('Fastidious','بسیار سخت‌گیر در جزئیات','/fæˈstɪdiəs/','He is fastidious about wording.','او دربارهٔ انتخاب واژه بسیار سخت‌گیر است.'),_Word('Inadvertently','ناخواسته','/ˌɪnədˈvɜːrtəntli/','I inadvertently omitted a detail.','ناخواسته جزئیاتی را حذف کردم.'),_Word('Incongruous','ناهمخوان','/ɪnˈkɑːŋɡruəs/','The tone felt incongruous.','لحن ناهمخوان به نظر می‌رسید.'),_Word('Perfunctory','سرسری و از روی رفع تکلیف','/pərˈfʌŋktəri/','He gave a perfunctory apology.','او عذرخواهی‌ای سرسری کرد.'),_Word('Apt','بجا و مناسب','/æpt/','That is an apt description.','این توصیف بجایی است.'),_Word('Ambivalent','دارای احساس دوگانه','/æmˈbɪvələnt/','I feel ambivalent about the proposal.','دربارهٔ پیشنهاد احساس دوگانه‌ای دارم.'),_Word('Circumspect','محتاط و سنجیده','/ˈsɜːrkəmspekt/','Be circumspect when making claims.','هنگام طرح ادعا محتاط باش.'),_Word('Equivocal','دوپهلو و مبهم','/ɪˈkwɪvəkəl/','His answer was equivocal.','پاسخش دوپهلو بود.'),_Word('Unambiguous','بی‌ابهام','/ˌʌnæmˈbɪɡjuəs/','The instructions must be unambiguous.','دستورها باید بی‌ابهام باشند.')]),
  _Topic('c2_discourse', 'C2', 'Complex discourse & synthesis', 'گفتمان پیچیده و ترکیب دیدگاه‌ها', '🧩',
    ['Synthesising viewpoints','Implicit meaning','Sophisticated transitions'], ['ترکیب دیدگاه‌ها','معنای ضمنی','پیوندهای پیشرفته'], ['🧠','🔍','🔗'],
    ['دیدگاه‌های متعارض را ترکیب کنی.','معنای ضمنی و لحن را تحلیل کنی.','متن پیچیده را منسجم پیوند بدهی.'],
    [_Word('Synthesis','ترکیب و تلفیق','/ˈsɪnθəsɪs/','The essay offers a synthesis of views.','مقاله تلفیقی از دیدگاه‌ها ارائه می‌کند.'),_Word('Subtext','معنای ضمنی','/ˈsʌbtekst/','The subtext is more revealing.','معنای ضمنی گویاتر است.'),_Word('Concomitant','همراه و هم‌زمان','/kənˈkɑːmɪtənt/','Growth has concomitant risks.','رشد با خطرات همراهی می‌کند.'),_Word('Notwithstanding','با وجود این','/ˌnɑːtwɪðˈstændɪŋ/','Notwithstanding the delay, we succeeded.','با وجود تأخیر، موفق شدیم.'),_Word('Conversely','برعکس','/ˈkɑːnvɜːrsli/','Conversely, the second option is cheaper.','برعکس، گزینهٔ دوم ارزان‌تر است.'),_Word('Henceforth','از این پس','/ˌhensˈfɔːrθ/','Henceforth, all reports will be digital.','از این پس همهٔ گزارش‌ها دیجیتال خواهند بود.'),_Word('Insofar as','تا آنجا که','/ˌɪnsoʊˈfɑːr æz/','Insofar as we can tell, it works.','تا آنجا که می‌توانیم تشخیص دهیم، کار می‌کند.'),_Word('Converge','همگرا شدن','/kənˈvɜːrdʒ/','The arguments converge on one point.','استدلال‌ها بر یک نکته همگرا می‌شوند.'),_Word('Divergence','واگرایی','/daɪˈvɜːrdʒəns/','There is a divergence of opinion.','اختلاف دیدگاه وجود دارد.')]),
];

