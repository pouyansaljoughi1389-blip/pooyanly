import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pouyanly/data/local/storage_service.dart';
import 'package:pouyanly/data/models/user_model.dart';
import 'package:pouyanly/features/vocabulary/services/vocabulary_fsrs_service.dart';
import 'package:pouyanly/shared/providers/user_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
  });

  test('all four FSRS ratings are persisted as independent review events', () async {
    final provider = UserProvider();
    await provider.createUser();
    final start = DateTime.utc(2026, 1, 1, 12);

    for (final rating in VocabularyReviewRating.values) {
      await provider.reviewVocabulary(
        'Hello',
        rating: rating,
        reviewedAt: start.add(Duration(days: provider.user!.vocabularyReviewHistory.length)),
      );
    }

    final user = provider.user!;
    expect(user.vocabularyFsrsCards.containsKey('hello'), isTrue);
    expect(user.vocabularyReviewHistory, hasLength(4));
    expect(user.vocabularyReviewHistory.map((entry) => entry['rating']).toSet(), {1, 2, 3, 4});
  });

  test('Again ratings increment mistake evidence and reset legacy repetition counter', () async {
    final provider = UserProvider();
    await provider.createUser();
    final now = DateTime.now().toUtc();

    await provider.reviewVocabulary(
      'Remember',
      rating: VocabularyReviewRating.good,
      reviewedAt: now,
    );
    await provider.reviewVocabulary(
      'Remember',
      rating: VocabularyReviewRating.again,
      reviewedAt: now.add(const Duration(days: 1)),
    );

    expect(provider.vocabularyMistakeCount, 1);
    expect(provider.user!.vocabularyReviewMistakes['remember'], 1);
    expect(provider.user!.vocabularyReviewRepetitions['remember'], 0);
  });

  test('legacy due date is preserved until first FSRS review', () async {
    final provider = UserProvider();
    await provider.createUser();
    final now = DateTime.now();
    final due = DateTime(now.year, now.month, now.day).add(const Duration(days: 3));
    final updated = provider.user!.copyWith(
      vocabularyReviewDueDates: {'legacy': due.toIso8601String()},
      vocabularyReviewIntervals: {'legacy': 3},
      vocabularyReviewRepetitions: {'legacy': 2},
    );
    await provider.updateUser(updated);

    expect(provider.isVocabularyDue('legacy', at: now), isFalse);
    expect(provider.isVocabularyDue('legacy', at: due.add(const Duration(days: 1))), isTrue);
  });

  test('FSRS card and review history survive user JSON persistence', () async {
    final provider = UserProvider();
    await provider.createUser();
    await provider.reviewVocabulary(
      'Thank you',
      rating: VocabularyReviewRating.good,
      reviewedAt: DateTime.utc(2026, 3, 4, 10),
    );

    final restored = StorageService.instance.loadUser()!;
    expect(restored.vocabularyFsrsCards['thank you'], isNotNull);
    expect(restored.vocabularyReviewHistory, hasLength(1));
    expect(restored.vocabularyReviewHistory.single['wordKey'], 'thank you');
    expect(
      VocabularyFsrsService.isDue(
        restored.vocabularyFsrsCards['thank you']!,
        at: DateTime.utc(2026, 3, 4, 10),
      ),
      isFalse,
    );
  });

  test('FSRS review history is capped to the latest 2000 events', () async {
    final provider = UserProvider();
    await provider.createUser();
    final seed = List<Map<String, dynamic>>.generate(
      2000,
      (index) => {'wordKey': 'seed-$index', 'rating': 3},
    );
    await provider.updateUser(
      provider.user!.copyWith(vocabularyReviewHistory: seed),
    );

    await provider.reviewVocabulary(
      'new word',
      rating: VocabularyReviewRating.good,
      reviewedAt: DateTime.now().toUtc(),
    );

    expect(provider.user!.vocabularyReviewHistory, hasLength(2000));
    expect(provider.user!.vocabularyReviewHistory.first['wordKey'], 'seed-1');
    expect(provider.user!.vocabularyReviewHistory.last['wordKey'], 'new word');
  });

  test('legacy user JSON without FSRS fields remains readable', () {
    final user = UserModel.fromJson({
      'id': 'legacy-user',
      'createdAt': '2025-01-01T00:00:00.000',
      'vocabularyReviewDueDates': {'word': '2025-01-02T00:00:00.000'},
      'vocabularyReviewIntervals': {'word': 1},
      'vocabularyReviewRepetitions': {'word': 1},
    });

    expect(user.vocabularyFsrsCards, isEmpty);
    expect(user.vocabularyReviewHistory, isEmpty);
    expect(user.vocabularyReviewDueDates['word'], '2025-01-02T00:00:00.000');
  });
}
