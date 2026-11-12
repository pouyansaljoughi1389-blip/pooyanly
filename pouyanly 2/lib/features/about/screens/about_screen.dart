import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const creatorName = 'Pouyan Saljoughi';
  static const creatorEmail = 'pouyansaljoughi1389@gmail.com';

  Future<void> _copy(BuildContext context, String value, String label) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label کپی شد', style: const TextStyle(fontFamily: 'Vazirmatn'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دربارهٔ POUYANLY')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withValues(alpha: .25), blurRadius: 28, offset: const Offset(0, 12)),
                const BoxShadow(color: Colors.white24, blurRadius: 2, offset: Offset(-2, -2)),
              ],
            ),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/app_icon.jpg',
                    width: 84,
                    height: 84,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 14),
                Text('POUYANLY', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
                SizedBox(height: 6),
                Text('یادگیری انگلیسی، قدم‌به‌قدم تا تسلط', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const Text('سازنده', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          _ContactTile(icon: Icons.person_rounded, title: 'نام', value: creatorName, onTap: () => _copy(context, creatorName, 'نام')),
          const SizedBox(height: 10),
          _ContactTile(icon: Icons.email_rounded, title: 'ایمیل', value: creatorEmail, onTap: () => _copy(context, creatorEmail, 'ایمیل')),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: .35)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 18, offset: const Offset(0, 8))],
            ),
            child: const Text(
              'POUYANLY یک پروژهٔ یادگیری زبان انگلیسی برای فارسی‌زبانان است. هدف آن ساختن مسیری مرحله‌به‌مرحله، تمرین‌محور و قابل استفاده به‌صورت آفلاین است.',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, height: 1.9),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'سورس آیکون‌ها و الهام طراحی',
            style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          _SourceTile(
            title: 'سکهٔ طلایی چرخان',
            creator: 'Ariadi Ahmad • LottieFiles',
            url: 'https://lottiefiles.com/free-animation/fintech-3d-rotating-gold-coin-animation-HsbBGvSL2Z',
          ),
          const SizedBox(height: 8),
          _SourceTile(
            title: 'شعلهٔ متحرک',
            creator: 'Izhar Hussain • LottieFiles',
            url: 'https://lottiefiles.com/free-animation/fire-flame-4De5RVVPag',
          ),
          const SizedBox(height: 8),
          _SourceTile(
            title: 'جام قهرمانی و دستاورد',
            creator: 'Mahendra Bhunwal • LottieFiles',
            url: 'https://lottiefiles.com/free-animation/trophy-yEGPe40FVr',
          ),
          const SizedBox(height: 10),
          const Text(
            'این صفحه‌ها مرجع الهام بصری هستند؛ فایل‌های Lottie آن‌ها داخل برنامه کپی نشده‌اند. آیکون‌های فعلی با نقاشی و انیمیشن بومی Flutter ساخته شده‌اند. برای فایل‌های عمومی LottieFiles، مجوز Lottie Simple License استفادهٔ تجاری و تغییر را مجاز می‌داند و ذکر نام سازنده را توصیه می‌کند.',
            style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, height: 1.8, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          const Center(child: Text('نسخهٔ آموزشی • ساخته‌شده با Flutter', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title, value;
  final VoidCallback onTap;
  const _ContactTile({required this.icon, required this.title, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: .35)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Row(children: [
          CircleAvatar(backgroundColor: AppColors.primary.withValues(alpha: .12), child: Icon(icon, color: AppColors.primary)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 3),
            SelectableText(value, style: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700, fontSize: 13)),
          ])),
          const Icon(Icons.copy_rounded, size: 18, color: AppColors.primary),
        ]),
      ),
    ),
  );
}


class _SourceTile extends StatelessWidget {
  final String title;
  final String creator;
  final String url;
  const _SourceTile({required this.title, required this.creator, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(creator, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 5),
          SelectableText(url, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
        ],
      ),
    );
  }
}
