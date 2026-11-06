import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _nameController = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_busy) return;
    setState(() => _busy = true);
    final provider = context.read<UserProvider>();
    final savedUser = provider.user;
    if (savedUser != null && savedUser.onboardingComplete) {
      if (!mounted) return;
      context.go(savedUser.placementTestComplete ? '/home' : '/placement-test');
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لطفاً نامت را وارد کن.')));
      return;
    }
    await provider.createUser(name: name);
    if (!mounted) return;
    context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final hasSavedProfile = context.watch<UserProvider>().user?.onboardingComplete == true;
    return Scaffold(
      appBar: AppBar(title: const Text('حساب POUYANLY')),
      body: ListView(padding: const EdgeInsets.all(22), children: [
        Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(
          gradient: AppColors.heroGradient, borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(.22), blurRadius: 24, offset: const Offset(0, 10))]),
          child: const Column(children: [
            CircleAvatar(radius: 35, backgroundColor: Colors.white, child: Text('🦁', style: TextStyle(fontSize: 40))),
            SizedBox(height: 12),
            Text('خوش برگشتی!', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)),
            SizedBox(height: 5),
            Text('پیشرفتت روی همین دستگاه ذخیره می‌شود.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 24),
        if (hasSavedProfile) ...[
          const Text('یک حساب محلی ذخیره‌شده پیدا شد.', style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _continue, icon: const Icon(Icons.login_rounded), label: const Text('ادامه با حساب ذخیره‌شده'))),
        ] else ...[
          const Text('ساخت پروفایل روی این دستگاه', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 17, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('این نسخه هنوز حساب ابری، رمز عبور یا همگام‌سازی بین دستگاه‌ها ندارد. نامت را وارد کن تا پروفایل محلی ساخته شود.', style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 12, height: 1.8)),
          const SizedBox(height: 16),
          TextField(controller: _nameController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'نام شما', hintText: 'مثلاً Pouyan')),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _busy ? null : _continue, icon: const Icon(Icons.person_add_alt_1_rounded), label: Text(_busy ? 'در حال ساخت...' : 'ساخت پروفایل و ادامه'))),
        ],
      ]),
    );
  }
}
