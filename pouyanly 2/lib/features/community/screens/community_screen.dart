import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Phase 4 foundation: a safety-first community entry point.
/// Social networking stays disabled until authentication, moderation and
/// server-side privacy controls are implemented.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('جامعهٔ POUYANLY')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.groups_rounded, color: Colors.white, size: 36),
                  SizedBox(height: 12),
                  Text(
                    'یادگیری در کنار دیگران',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'بخش اجتماعی در حال آماده‌سازی است. اولویت ما ساخت فضایی امن، محترمانه و مناسب زبان‌آموزان است.',
                    style: TextStyle(
                      fontFamily: 'Vazirmatn',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const _SafetyItem(
              icon: Icons.verified_user_outlined,
              title: 'حریم خصوصی در اولویت',
              description:
                  'پروفایل‌ها و اطلاعات شخصی تا زمان آماده‌شدن تنظیمات واقعی حریم خصوصی، عمومی نمی‌شوند.',
            ),
            const _SafetyItem(
              icon: Icons.flag_outlined,
              title: 'گزارش و رسیدگی',
              description:
                  'پیش از فعال‌شدن گفتگوها، سازوکار گزارش محتوا و رسیدگی به تخلف باید پیاده‌سازی و آزمایش شود.',
            ),
            const _SafetyItem(
              icon: Icons.block_outlined,
              title: 'مسدودسازی و کنترل ارتباط',
              description:
                  'ابزارهای مسدودسازی، کنترل درخواست دوستی و محدودکردن ارتباط باید قبل از پیام‌رسانی آماده باشند.',
            ),
            const _SafetyItem(
              icon: Icons.handshake_outlined,
              title: 'رفتار محترمانه',
              description:
                  'آزار، تهدید، انتشار اطلاعات شخصی دیگران و محتوای نامناسب در جامعه پذیرفته نیست.',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'وضعیت: پیش‌نمایش آفلاین — هنوز حساب اجتماعی، جست‌وجوی کاربران، درخواست دوستی یا پیام‌رسانی فعال نیست.',
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _SafetyItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.12),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12),
        ),
      ),
    );
  }
}
