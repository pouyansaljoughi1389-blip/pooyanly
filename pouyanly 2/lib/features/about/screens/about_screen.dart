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
                BoxShadow(color: AppColors.primary.withOpacity(.25), blurRadius: 28, offset: const Offset(0, 12)),
                const BoxShadow(color: Colors.white24, blurRadius: 2, offset: Offset(-2, -2)),
              ],
            ),
            child: const Column(
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
              border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(.35)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 18, offset: const Offset(0, 8))],
            ),
            child: const Text(
              'POUYANLY یک پروژهٔ یادگیری زبان انگلیسی برای فارسی‌زبانان است. هدف آن ساختن مسیری مرحله‌به‌مرحله، تمرین‌محور و قابل استفاده به‌صورت آفلاین است.',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, height: 1.9),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text('نسخهٔ آموزشی • ساخته‌شده با Flutter', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: AppColors.textSecondaryLight))),
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
          border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(.35)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Row(children: [
          CircleAvatar(backgroundColor: AppColors.primary.withOpacity(.12), child: Icon(icon, color: AppColors.primary)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, color: AppColors.textSecondaryLight)),
            const SizedBox(height: 3),
            SelectableText(value, style: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700, fontSize: 13)),
          ])),
          const Icon(Icons.copy_rounded, size: 18, color: AppColors.primary),
        ]),
      ),
    ),
  );
}
