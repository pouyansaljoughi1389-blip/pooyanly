import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/providers/user_provider.dart';
import '../../lessons/models/lesson_data.dart';

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

  List<VocabularyItem> get _allVocab {
    final all = <VocabularyItem>[];
    for (final unit in CourseData.getAllUnits()) {
      for (final lesson in unit.lessons) {
        all.addAll(lesson.vocabulary);
      }
    }
    return all;
  }

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
                '${vocab.length} کلمه',
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
                Text(
                  widget.item.exampleEn,
                  style: const TextStyle(
                    fontFamily: 'Vazirmatn',
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondaryLight,
                  ),
                  textDirection: TextDirection.ltr,
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

  List<VocabularyItem> get _reviewItems {
    // In a real app, SRS algorithm picks items due for review.
    // Here we show first 10 items as a demo.
    final all = <VocabularyItem>[];
    for (final unit in CourseData.a1Units) {
      for (final lesson in unit.lessons) {
        all.addAll(lesson.vocabulary);
        if (all.length >= 10) break;
      }
      if (all.length >= 10) break;
    }
    return all;
  }

  @override
  Widget build(BuildContext context) {
    final items = _reviewItems;

    if (items.isEmpty) {
      return const Center(
        child: Text('هنوز لغتی برای مرور وجود ندارد',
            style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 15)),
      );
    }

    if (_reviewIndex >= items.length) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text('مرور امروز تمام شد!',
                style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() => _reviewIndex = 0),
              child: const Text('مرور دوباره', style: TextStyle(fontFamily: 'Vazirmatn')),
            ),
          ],
        ),
      );
    }

    final item = items[_reviewIndex];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Counter
          Text(
            '${_reviewIndex + 1} از ${items.length}',
            style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 16),

          // Card
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _revealed = true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: _revealed ? AppColors.primaryGradient : const LinearGradient(colors: [Color(0xFFf8f7ff), Color(0xFFf0eeff)]),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.english,
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: _revealed ? Colors.white : AppColors.primary,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.pronunciation,
                      style: TextStyle(
                        fontFamily: 'Vazirmatn',
                        fontSize: 15,
                        color: _revealed ? Colors.white70 : AppColors.textSecondaryLight,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                    if (_revealed) ...[
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white30),
                      const SizedBox(height: 16),
                      Text(
                        item.farsi,
                        style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(item.exampleFa,
                          style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, color: Colors.white70),
                          textAlign: TextAlign.center),
                    ] else ...[
                      const SizedBox(height: 24),
                      const Text('برای دیدن معنی ضربه بزنید',
                          style: TextStyle(fontFamily: 'Vazirmatn', fontSize: 13, color: AppColors.textSecondaryLight)),
                    ],
                  ],
                ),
              ),
            ),
          ),

          if (_revealed) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() { _reviewIndex++; _revealed = false; }),
                    icon: const Icon(Icons.close_rounded, color: AppColors.error),
                    label: const Text('اشتباه بودم', style: TextStyle(fontFamily: 'Vazirmatn', color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => setState(() { _reviewIndex++; _revealed = false; }),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('بلد بودم', style: TextStyle(fontFamily: 'Vazirmatn')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
