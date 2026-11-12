import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/persian_digits.dart';
import '../../../shared/providers/user_provider.dart';
import '../../lessons/models/lesson_data.dart';
import '../services/vocabulary_audio_service.dart';

class VocabularyScreen extends StatefulWidget {
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  List<VocabularyItem> get _allVocab => CourseData.getAllVocabulary();

  List<VocabularyItem> get _filteredVocab {
    if (_search.isEmpty) return _allVocab;
    final q = _search.toLowerCase();
    return _allVocab.where((v) =>
        v.english.toLowerCase().contains(q) ||
        v.farsi.contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لغت‌نامه',
              style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700)),
          bottom: TabBar(
            controller: _tabs,
            labelStyle: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Vazirmatn'),
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            tabs: const [
              Tab(text: 'همه لغت‌ها'),
              Tab(text: 'مرور SRS'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabs,
          children: [
            _AllVocabTab(
              vocab: _filteredVocab,
              search: _search,
              onSearchChanged: (v) => setState(() => _search = v),
            ),
            const _ReviewTab(),
          ],
        ),
      ),
    );
  }
}

// ── All Vocab Tab ─────────────────────────────────────────────────────────────

class _AllVocabTab extends StatelessWidget {
  final List<VocabularyItem> vocab;
  final String search;
  final ValueChanged<String> onSearchChanged;

  const _AllVocabTab({
    required this.vocab,
    required this.search,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'جستجوی کلمه...',
              hintStyle: const TextStyle(fontFamily: 'Vazirmatn'),
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondaryLight),
              suffixIcon: search.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () => onSearchChanged(''),
                    )
                  : null,
            ),
            onChanged: onSearchChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${toPersianDigits(vocab.length)} کلمه',
                style: const TextStyle(
                  fontFamily: 'Vazirmatn',
                  fontSize: 13,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: vocab.length,
            itemBuilder: (ctx, i) => _VocabTile(item: vocab[i]),
          ),
        ),
      ],
    );
  }
}

class _VocabTile extends StatefulWidget {
  final VocabularyItem item;
  const _VocabTile({required this.item});

  @override
  State<_VocabTile> createState() => _VocabTileState();
}

class _VocabTileState extends State<_VocabTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.cefrColor(widget.item.cefrLevel);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: InkWell(
        onTap: () => setState(() => _expanded = !_expanded),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.english,
                          style: const TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                        Text(
                          widget.item.pronunciation,
                          style: const TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'پخش تلفظ انگلیسی',
                    visualDensity: VisualDensity.compact,
                    onPressed: () async {
                      final played = await VocabularyAudioService.instance
                          .speak(widget.item.english);
                      if (!played && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('موتور تبدیل متن به گفتار در دسترس نیست.'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.volume_up_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.item.cefrLevel,
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.item.farsi,
                    style: const TextStyle(
                      fontFamily: 'Vazirmatn',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    _expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    size: 18,
                    color: AppColors.textSecondaryLight,
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.item.exampleEn,
                        style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondaryLight,
                  ),
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                    IconButton(
                      tooltip: 'پخش جمله نمونه',
                      onPressed: () async {
                        final played = await VocabularyAudioService.instance
                            .speak(widget.item.exampleEn, rate: 0.38);
                        if (!played && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('موتور تبدیل متن به گفتار در دسترس نیست.'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.volume_up_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.item.exampleFa,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 13,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Review Tab ────────────────────────────────────────────────────────────────

class _ReviewTab extends StatefulWidget {
  const _ReviewTab();

  @override
  State<_ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<_ReviewTab> {
  int _reviewIndex = 0;
  bool _revealed = false;
  bool _sessionInitialized = false;
  List<VocabularyItem> _sessionItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_sessionInitialized) {
      _refreshSession();
      _sessionInitialized = true;
    }
  }

  void _refreshSession() {
    final provider = context.read<UserProvider>();
    _sessionItems = _allReviewItems
        .where((item) => provider.isVocabularyDue(item.english))
        .toList();
  }

  List<VocabularyItem> get _allReviewItems => CourseData.getAllVocabulary();

  @override
  Widget build(BuildContext context) {
    context.watch<UserProvider>();
    final items = _sessionItems;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text('🎉', style: TextStyle(fontSize: 56)),
              SizedBox(height: 16),
              Text('همه‌چیز مرتبه!', style: TextStyle(
                fontFamily: 'Vazirmatn', fontSize: 22, fontWeight: FontWeight.w800)),
              SizedBox(height: 8),
              Text('فعلاً لغت عقب‌افتاده‌ای نداری. فردا دوباره سر بزن.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Vazirmatn', color: AppColors.textSecondaryLight)),
            ],
          ),
        ),
      );
    }

    if (_reviewIndex >= items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 58)),
            const SizedBox(height: 16),
            const Text('مرور امروز تمام شد!',
              style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('${toPersianDigits(items.length)} لغت را مرور کردی.',
              style: const TextStyle(fontFamily: 'Vazirmatn')),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() { _refreshSession(); _reviewIndex = 0; _revealed = false; }),
              child: const Text('بررسی دوباره', style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
          ],
        ),
      );
    }

    final item = items[_reviewIndex];
    Future<void> submitReview(bool remembered) async {
      await context.read<UserProvider>().reviewVocabulary(
        item.english,
        remembered: remembered,
      );
      if (!mounted) return;
      setState(() { _reviewIndex++; _revealed = false; });
    }

    final reviewProvider = context.watch<UserProvider>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _ReviewStat(
                title: 'تسلط واژه‌های مرورشده',
                value: '${toPersianDigits(reviewProvider.vocabularyMasteryPercent.toStringAsFixed(0))}٪',
                icon: Icons.auto_graph_rounded,
              )),
              const SizedBox(width: 10),
              Expanded(child: _ReviewStat(
                title: 'خطاهای ثبت‌شده',
                value: '${toPersianDigits(reviewProvider.vocabularyMistakeCount)}',
                icon: Icons.refresh_rounded,
              )),
            ],
          ),
          const SizedBox(height: 14),
          Text('${toPersianDigits(_reviewIndex + 1)} از ${toPersianDigits(items.length)} لغتِ موعددار',
            style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13,
              color: AppColors.textSecondaryLight)),
          const SizedBox(height: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _revealed = true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: _revealed ? AppColors.primaryGradient :
                    const LinearGradient(colors: [Color(0xFFF8F7FF), Color(0xFFF0EEFF)]),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item.english, textDirection: TextDirection.ltr,
                      style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: _revealed ? Colors.white : AppColors.primary)),
                    const SizedBox(height: 8),
                    Text(item.pronunciation, textDirection: TextDirection.ltr,
                      style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15,
                        color: _revealed ? Colors.white70 : AppColors.textSecondaryLight)),
                    if (_revealed) ...[
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white30),
                      const SizedBox(height: 16),
                      Text(item.farsi, textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 30,
                          fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 12),
                      Text(item.exampleEn, textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 14,
                          color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(item.exampleFa, textAlign: TextAlign.center,
                        style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13,
                          color: Colors.white70)),
                    ] else ...[
                      const SizedBox(height: 24),
                      const Text('معنی را در ذهنت حدس بزن؛ سپس کارت را لمس کن.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13,
                          color: AppColors.textSecondaryLight)),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (_revealed) ...[
            const SizedBox(height: 18),
            Row(children: [
              Expanded(child: OutlinedButton.icon(
                onPressed: () => submitReview(false),
                icon: const Icon(Icons.refresh_rounded, color: AppColors.error),
                label: const Text('هنوز یاد نگرفتم',
                  style: TextStyle(fontFamily: 'Vazirmatn', color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(
                onPressed: () => submitReview(true),
                icon: const Icon(Icons.check_rounded),
                label: const Text('بلدم', style: TextStyle(fontFamily: 'Vazirmatn')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              )),
            ]),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ReviewStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _ReviewStat({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerLight),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Vazirmatn',
                fontSize: 10, color: AppColors.textSecondaryLight)),
              Text(value, style: const TextStyle(fontFamily: 'Vazirmatn',
                fontSize: 17, fontWeight: FontWeight.w800)),
            ],
          )),
        ],
      ),
    );
  }
}
