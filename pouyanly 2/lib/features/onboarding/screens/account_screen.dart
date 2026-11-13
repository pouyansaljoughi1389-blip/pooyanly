import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../core/services/learning_reminder_service.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _contact = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _contact.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_busy) return;
    final first = _firstName.text.trim();
    final last = _lastName.text.trim();
    final contact = _contact.text.trim();
    final isEmail = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(contact);
    final isPhone = RegExp(r'^\+?[0-9\s()\-]{7,20}$').hasMatch(contact);
    if (first.isEmpty || last.isEmpty || (!isEmail && !isPhone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('نام، نام خانوادگی و یک ایمیل یا شمارهٔ معتبر وارد کن.'),
        ),
      );
      return;
    }

    setState(() => _busy = true);
    try {
      await context.read<UserProvider>().createUser(
        firstName: first,
        lastName: last,
        contact: contact,
        contactType: isEmail ? 'email' : 'phone',
      );
      await LearningReminderService.restore();
      if (mounted) context.go('/onboarding');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ذخیرهٔ اطلاعات انجام نشد. دوباره تلاش کن.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final saved = context.watch<UserProvider>().user;
    final hasSavedProfile = saved?.onboardingComplete == true;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('ثبت‌نام در POUYANLY')),
        body: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: .22), blurRadius: 24, offset: const Offset(0, 10))],
              ),
              child: const Column(children: [
                Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 42),
                SizedBox(height: 12),
                Text('مسیر انگلیسی تو از اینجا شروع می‌شود', textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                SizedBox(height: 7),
                Text('اطلاعاتت را وارد کن تا پروفایل یادگیری ساخته شود.', textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white.withValues(alpha: .92), fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 24),
            if (hasSavedProfile) ...[
              Text('خوش برگشتی، ${saved?.name ?? 'زبان‌آموز'}!',
                style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => context.go(saved?.placementTestComplete == true ? '/home' : '/placement-test'),
                icon: const Icon(Icons.login_rounded),
                label: const Text('ادامه با پروفایل این دستگاه'),
              ),
            ] else ...[
              const Text('اطلاعات ثبت‌نام', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 17, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              TextField(controller: _firstName, textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'نام', prefixIcon: Icon(Icons.person_outline_rounded))),
              const SizedBox(height: 12),
              TextField(controller: _lastName, textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'نام خانوادگی', prefixIcon: Icon(Icons.badge_outlined))),
              const SizedBox(height: 12),
              TextField(controller: _contact, keyboardType: TextInputType.text,
                autofillHints: const [AutofillHints.email, AutofillHints.telephoneNumber],
                decoration: const InputDecoration(labelText: 'ایمیل یا شماره تلفن', hintText: 'name@example.com یا 09…', prefixIcon: Icon(Icons.alternate_email_rounded))),
              const SizedBox(height: 10),
              Text('فعلاً اطلاعات فقط به‌صورت محلی ذخیره می‌شوند؛ کد تأیید و اتصال به سرویس حساب کاربری در مرحلهٔ بعد اضافه خواهد شد.',
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11, height: 1.7, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              SizedBox(width: double.infinity, child: FilledButton.icon(
                onPressed: _busy ? null : _continue,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(_busy ? 'در حال ذخیره…' : 'ساخت پروفایل و ادامه'),
              )),
            ],
          ],
        ),
      ),
    );
  }
}
