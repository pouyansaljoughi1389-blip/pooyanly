import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../../shared/providers/user_provider.dart';
import '../services/tutor_engine.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});
  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorMessage {
  final String text;
  final bool fromTutor;
  const _TutorMessage(this.text, {required this.fromTutor});
}

class _TutorScreenState extends State<TutorScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_TutorMessage> _messages = [
    const _TutorMessage(
      'سلام! من پویان سلجوقی هستم. در جواب به سؤال شما کمک می‌کنم. معنی یک واژه، تلفظ و مثالش را بپرس یا یک نکتهٔ گرامری مطرح کن.',
      fromTutor: true,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final user = context.read<UserProvider>().user;
    final reply = TutorEngine.reply(
      message: text,
      skillScores: user?.skillScores ?? const {},
      level: user?.cefrLevel ?? CefrLevel.unknown,
    );
    setState(() {
      _messages.add(_TutorMessage(text, fromTutor: false));
      _messages.add(_TutorMessage(reply, fromTutor: true));
      _controller.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('معلم زبان POUYANLY',
              style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: AppColors.primary.withOpacity(0.08),
              child: const Text(
                'فرهنگ لغت و پاسخ‌های آموزشی آفلاین • برای پاسخ آزاد به هر موضوعی هنوز مدل هوش مصنوعی مولد متصل نیست.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 11),
              ),
            ),
            if (user != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text('سطح فعلی: ${user.cefrLevel.label}',
                      style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12,
                          color: AppColors.textSecondaryLight)),
                ),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.fromTutor ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.84),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: message.fromTutor
                            ? Theme.of(context).cardColor
                            : AppColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.dividerLight),
                      ),
                      child: Text(message.text,
                          style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, height: 1.7)),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          hintText: 'یک جمله یا سؤال بنویس...',
                          hintTextDirection: TextDirection.rtl,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(onPressed: _send, icon: const Icon(Icons.send_rounded), tooltip: 'ارسال'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
