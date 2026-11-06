import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../vocabulary/services/vocabulary_audio_service.dart';
import '../models/listening_data.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  int _index = 0;
  String? _selected;
  bool _answered = false;
  int _correct = 0;
  bool _finished = false;

  ListeningExercise get _current => ListeningData.exercises[_index];

  Future<void> _play() async {
    final played = await VocabularyAudioService.instance.speak(
      _current.dialogue, rate: 0.40);
    if (!played && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('موتور صدای انگلیسی در دسترس نیست.')),
      );
    }
  }

  void _select(String option) {
    if (_answered) return;
    setState(() {
      _selected = option;
      _answered = true;
      if (option == _current.answer) _correct++;
    });
  }

  void _next() {
    if (_index == ListeningData.exercises.length - 1) {
      setState(() => _finished = true);
      return;
    }
    setState(() {
      _index++;
      _selected = null;
      _answered = false;
    });
  }

  void _restart() {
    setState(() {
      _index = 0;
      _selected = null;
      _answered = false;
      _correct = 0;
      _finished = false;
    });
  }

  @override
  void dispose() {
    VocabularyAudioService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('آزمایشگاه شنیداری',
          style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: _finished ? _result() : _exercise(),
      ),
    );
  }

  Widget _exercise() {
    final item = _current;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (_index + 1) / ListeningData.exercises.length,
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text('${_index + 1}/${ListeningData.exercises.length}',
              style: const TextStyle(fontFamily: 'Vazirmatn')),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(item.level, style: const TextStyle(
                color: Colors.white70, fontFamily: 'Vazirmatn')),
              const SizedBox(height: 8),
              Text(item.title, textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 22,
                  fontWeight: FontWeight.w700, fontFamily: 'Vazirmatn')),
              const SizedBox(height: 16),
              IconButton.filled(
                onPressed: _play,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  fixedSize: const Size(64, 64),
                ),
                icon: const Icon(Icons.play_arrow_rounded, size: 36),
                tooltip: 'پخش مکالمه',
              ),
              const SizedBox(height: 8),
              const Text('به مکالمه گوش کن؛ متن آن نمایش داده نمی‌شود.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontFamily: 'Vazirmatn',
                  fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(item.question, textDirection: TextDirection.ltr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        ...item.options.map((option) {
          final isSelected = option == _selected;
          final isCorrect = option == item.answer;
          Color? background;
          Color? border;
          if (_answered && isCorrect) {
            background = AppColors.success.withOpacity(0.12);
            border = AppColors.success;
          } else if (_answered && isSelected) {
            background = AppColors.error.withOpacity(0.10);
            border = AppColors.error;
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: background ?? Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: _answered ? null : () => _select(option),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: border ?? AppColors.dividerLight),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(option, textDirection: TextDirection.ltr,
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                      if (_answered && isCorrect)
                        const Icon(Icons.check_circle, color: AppColors.success),
                      if (_answered && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: AppColors.error),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        if (_answered) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_selected == item.answer ? 'آفرین! پاسخ درست است.' : 'این بار درست نبود.'} ${item.explanation}',
              style: const TextStyle(fontFamily: 'Vazirmatn'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _next,
            child: Text(_index == ListeningData.exercises.length - 1
              ? 'دیدن نتیجه' : 'تمرین بعدی',
              style: const TextStyle(fontFamily: 'Vazirmatn')),
          ),
        ],
      ],
    );
  }

  Widget _result() {
    final total = ListeningData.exercises.length;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.headphones_rounded, size: 64, color: AppColors.primary),
            const SizedBox(height: 18),
            const Text('تمرین شنیداری تمام شد!',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 22,
                fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text('$_correct از $total پاسخ درست',
              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 18)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _restart,
                child: const Text('تکرار تمرین‌ها',
                  style: TextStyle(fontFamily: 'Vazirmatn')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
