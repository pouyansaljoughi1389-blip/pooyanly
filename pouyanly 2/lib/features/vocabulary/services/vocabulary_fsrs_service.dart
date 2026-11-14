import 'package:fsrs/fsrs.dart' as fsrs;

/// The four recall grades supported by FSRS-6.
enum VocabularyReviewRating { again, hard, good, easy }

class VocabularyFsrsReviewResult {
  final Map<String, dynamic> card;
  final Map<String, dynamic> reviewLog;
  final DateTime due;

  const VocabularyFsrsReviewResult({
    required this.card,
    required this.reviewLog,
    required this.due,
  });
}

/// Adapter isolating the app from the third-party FSRS API.
class VocabularyFsrsService {
  VocabularyFsrsService._();

  static final fsrs.Scheduler _scheduler = fsrs.Scheduler(
    desiredRetention: 0.9,
    maximumInterval: 36500,
  );

  static fsrs.Rating _toFsrsRating(VocabularyReviewRating rating) {
    switch (rating) {
      case VocabularyReviewRating.again:
        return fsrs.Rating.again;
      case VocabularyReviewRating.hard:
        return fsrs.Rating.hard;
      case VocabularyReviewRating.good:
        return fsrs.Rating.good;
      case VocabularyReviewRating.easy:
        return fsrs.Rating.easy;
    }
  }

  static int _stableCardId(String normalizedWord) {
    var hash = 0x811c9dc5;
    for (final unit in normalizedWord.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }

  /// Restores saved FSRS state or creates a learning card.
  ///
  /// Legacy due dates are retained during first-use migration. Legacy
  /// repetition counts are deliberately not converted into invented FSRS
  /// stability/difficulty values because those parameters cannot be inferred.
  static fsrs.Card _restoreCard({
    required String normalizedWord,
    Map<String, dynamic>? savedCard,
    DateTime? legacyDueAt,
    required DateTime now,
  }) {
    if (savedCard != null) {
      return fsrs.Card.fromMap(Map<String, dynamic>.from(savedCard));
    }
    return fsrs.Card(
      cardId: _stableCardId(normalizedWord),
      due: (legacyDueAt ?? now).toUtc(),
    );
  }

  static VocabularyFsrsReviewResult review({
    required String normalizedWord,
    required VocabularyReviewRating rating,
    Map<String, dynamic>? savedCard,
    DateTime? legacyDueAt,
    DateTime? reviewedAt,
  }) {
    final now = (reviewedAt ?? DateTime.now()).toUtc();
    final card = _restoreCard(
      normalizedWord: normalizedWord,
      savedCard: savedCard,
      legacyDueAt: legacyDueAt,
      now: now,
    );
    final result = _scheduler.reviewCard(
      card,
      _toFsrsRating(rating),
      reviewDateTime: now,
    );
    return VocabularyFsrsReviewResult(
      card: result.card.toMap(),
      reviewLog: result.reviewLog.toMap(),
      due: result.card.due.toUtc(),
    );
  }

  static bool isDue(Map<String, dynamic> savedCard, {DateTime? at}) {
    final card = fsrs.Card.fromMap(Map<String, dynamic>.from(savedCard));
    return !card.due.toUtc().isAfter((at ?? DateTime.now()).toUtc());
  }

  /// Returns FSRS' predicted probability of recall; null for unreviewed cards.
  static double? predictedRetrievability(
    Map<String, dynamic> savedCard, {
    DateTime? at,
  }) {
    final card = fsrs.Card.fromMap(Map<String, dynamic>.from(savedCard));
    if (card.stability == null) return null;
    return _scheduler.getCardRetrievability(
      card,
      currentDateTime: (at ?? DateTime.now()).toUtc(),
    );
  }
}
