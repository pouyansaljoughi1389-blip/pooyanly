import '../../../data/models/user_model.dart';

/// Offline coaching scaffold; this is not a generative AI model.
class TutorEngine {
  TutorEngine._();

  static String reply({
    required String message,
    required Map<String, int> skillScores,
    required CefrLevel level,
  }) {
    final input = message.trim();
    if (input.isEmpty) return 'یک جمله یا سؤال کوتاه بنویس تا با هم بررسی‌اش کنیم.';
    final lower = input.toLowerCase();
    if (RegExp(r'\b(hello|hi|hey)\b').hasMatch(lower)) {
      return 'Hello! یعنی «سلام». یک پاسخ طبیعی می‌تواند این باشد: “Hi! How are you?” حالا تو هم یک احوال‌پرسی انگلیسی بنویس.';
    }
    if (lower.contains('i am agree') || lower.contains('am agree')) {
      return 'شکل درست “I agree” است، نه “I am agree”. فعل agree خودش فعل اصلی است و در حال ساده به am نیاز ندارد. مثال: “I agree with you.”';
    }
    if (lower.contains('she go') || lower.contains('he go')) {
      return 'در زمان حال ساده، برای he و she معمولاً به فعل s اضافه می‌کنیم: “She goes to school.” حالا یک جمله با he یا she بساز.';
    }
    if (lower.contains('past simple') || lower.contains('گذشته ساده')) {
      return 'برای Past Simple از شکل گذشتهٔ فعل استفاده می‌کنیم: “I played football yesterday.” برای فعل‌های باقاعده معمولاً ed می‌آید؛ بعضی فعل‌ها بی‌قاعده‌اند، مثل go → went.';
    }
    final weakest = skillScores.entries.isEmpty
        ? null
        : skillScores.entries.reduce((a, b) => a.value <= b.value ? a : b);
    final focus = switch (weakest?.key) {
      'vocabulary' => 'واژگان',
      'grammar' => 'گرامر',
      'reading' => 'درک مطلب',
      _ => 'ساخت جمله',
    };
    return 'سطح ثبت‌شدهٔ تو \${level.label} است و تمرکز پیشنهادی فعلی: $focus. '
        'برای اینکه دقیق‌تر راهنمایی‌ات کنم، یک جملهٔ انگلیسی دربارهٔ امروزت بنویس؛ '
        'این نسخهٔ آزمایشی پاسخ‌های ازپیش‌تعریف‌شده دارد و هنوز به مدل مولد هوش مصنوعی متصل نیست.';
  }
}
