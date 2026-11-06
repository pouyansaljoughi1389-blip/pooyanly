import '../../../data/models/user_model.dart';
import 'english_dictionary.dart';

/// Offline tutor. It searches the bundled course lexicon and teaches common
/// grammar patterns; it is not a generative AI model.
class TutorEngine {
  TutorEngine._();

  static const _opening = 'سلام، من پویان سلجوقی هستم. در پاسخ به سؤال شما: ';

  static String reply({
    required String message,
    required Map<String, int> skillScores,
    required CefrLevel level,
  }) {
    final input = message.trim();
    if (input.isEmpty) return 'یک جمله یا سؤال کوتاه بنویس تا با هم بررسی‌اش کنیم.';
    final lower = input.toLowerCase();

    if (RegExp(r'\b(hello|hi|hey)\b').hasMatch(lower)) {
      return _opening + 'Hello یعنی «سلام». یک پاسخ طبیعی می‌تواند این باشد: “Hi! How are you?” حالا تو هم یک احوال‌پرسی انگلیسی بنویس.';
    }
    if (lower.contains('i am agree') || lower.contains('am agree')) {
      return _opening + 'شکل درست “I agree” است، نه “I am agree”. فعل agree خودش فعل اصلی است و در حال ساده به am نیاز ندارد. مثال: “I agree with you.”';
    }
    if (lower.contains('she go') || lower.contains('he go')) {
      return _opening + 'در زمان حال ساده، برای he و she معمولاً به فعل s اضافه می‌کنیم: “She goes to school.” حالا یک جمله با he یا she بساز.';
    }
    if (lower.contains('past simple') || lower.contains('گذشته ساده')) {
      return _opening + 'برای Past Simple از شکل گذشتهٔ فعل استفاده می‌کنیم: “I played football yesterday.” برای فعل‌های باقاعده معمولاً ed می‌آید؛ بعضی فعل‌ها بی‌قاعده‌اند، مثل go → went.';
    }
    if (lower.contains('present perfect') || lower.contains('حال کامل')) {
      return _opening + 'ساختار Present Perfect برابر have/has + past participle است؛ مثلاً “I have finished my homework.” وقتی نتیجه یا تجربه به زمان حال ارتباط دارد، از آن استفاده می‌کنیم.';
    }
    if (lower.contains('will') || lower.contains('going to') || lower.contains('آینده')) {
      return _opening + 'برای آینده، will اغلب برای تصمیم لحظه‌ای یا پیش‌بینی و be going to برای قصد قبلی یا نشانهٔ فعلی به کار می‌رود. مثال: “I’ll help you” و “I’m going to study tonight.”';
    }
    if (lower.contains('معنی') || lower.contains('ترجمه') || lower.contains('یعنی')) {
      final entry = EnglishDictionary.find(input) ?? EnglishDictionary.findByPersian(input);
      if (entry != null) return _dictionaryReply(entry);
    }
    final entry = EnglishDictionary.find(input) ?? EnglishDictionary.findByPersian(input);
    if (entry != null) return _dictionaryReply(entry);

    final weakest = skillScores.entries.isEmpty
        ? null
        : skillScores.entries.reduce((a, b) => a.value <= b.value ? a : b);
    final focus = switch (weakest?.key) {
      'vocabulary' => 'واژگان',
      'grammar' => 'گرامر',
      'reading' => 'درک مطلب',
      _ => 'ساخت جمله',
    };
    return _opening + 'سطح ثبت‌شدهٔ تو ${level.label} است و تمرکز پیشنهادی فعلی: $focus. '
        'می‌توانم واژه‌های موجود در فرهنگ لغت آفلاین و چند ساختار رایج گرامری را توضیح بدهم. '
        'برای پرسش‌های آزاد و پاسخ به هر موضوعی، این نسخه هنوز به مدل هوش مصنوعی مولد متصل نیست؛ '
        'پس اگر واژه‌ای در فرهنگ لغت نباشد، پاسخ ساختگی نمی‌دهم.';
  }

  static String _dictionaryReply(DictionaryEntry entry) =>
      _opening + '«${entry.word}» یعنی «${entry.meaning}».\n'
      'تلفظ: ${entry.pronunciation}\n'
      'مثال: ${entry.example}\n'
      'ترجمه: ${entry.exampleFa}';
}
