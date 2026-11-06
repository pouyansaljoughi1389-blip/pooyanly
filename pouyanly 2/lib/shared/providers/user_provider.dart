import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/local/storage_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  List<Map<String, dynamic>> _assessmentHistory = [];
  List<Map<String, dynamic>> get assessmentHistory => List.unmodifiable(_assessmentHistory);

  // ── Init ──────────────────────────────────────────────────────────
  Future<void> init() async {
    _user = StorageService.instance.loadUser();
    _assessmentHistory = StorageService.instance.loadAssessmentHistory();
    notifyListeners();
  }

  // ── Create ────────────────────────────────────────────────────────
  Future<void> createUser({String? name}) async {
    _user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      createdAt: DateTime.now(),
    );
    await _save();
  }

  // ── Update ────────────────────────────────────────────────────────
  Future<void> updateUser(UserModel updated) async {
    _user = updated;
    await _save();
  }

  // ── Onboarding ────────────────────────────────────────────────────
  Future<void> setOnboardingData({
    required LearningGoal goal,
    required EngLevel level,
    required StudyTime time,
    required StudyPeriod period,
    String? name,
  }) async {
    _user = (_user ?? UserModel(id: DateTime.now().millisecondsSinceEpoch.toString(), createdAt: DateTime.now()))
        .copyWith(
          name: name ?? _user?.name ?? 'زبان‌آموز',
          goal: goal,
          selfAssessedLevel: level,
          dailyStudyTime: time,
          preferredStudyTime: period,
          onboardingComplete: true,
        );
    await _save();
  }

  // ── Placement Test ────────────────────────────────────────────────
  Future<void> completePlacementTest({
    required CefrLevel cefrLevel,
    required Map<String, int> skillScores,
    Map<String, double> levelScores = const {},
  }) async {
    final snapshot = <String, dynamic>{
      'takenAt': DateTime.now().toIso8601String(),
      'cefrLevel': cefrLevel.name,
      'skillScores': skillScores,
      'levelScores': levelScores,
    };
    _assessmentHistory = [..._assessmentHistory, snapshot];
    await StorageService.instance.appendAssessment(snapshot);
    _user = _user?.copyWith(
      cefrLevel: cefrLevel,
      skillScores: skillScores,
      placementTestComplete: true,
    );
    await _save();
  }

  // ── XP & Coins ────────────────────────────────────────────────────
  Future<void> addXP(int amount) async {
    if (_user == null) return;
    _user = _user!.copyWith(xp: _user!.xp + amount);
    await _save();
  }

  Future<void> addCoins(int amount) async {
    if (_user == null) return;
    _user = _user!.copyWith(coins: _user!.coins + amount);
    await _save();
  }

  // ── Lesson Completion ─────────────────────────────────────────────
  Future<void> completeLesson(String lessonId, {int xpGain = 20, int coinGain = 5}) async {
    final currentUser = _user;
    if (currentUser == null || lessonId.trim().isEmpty) return;

    // A completed lesson must never grant XP or coins more than once.
    if (currentUser.completedLessonIds.contains(lessonId)) return;

    final ids = List<String>.from(currentUser.completedLessonIds)..add(lessonId);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final last = currentUser.lastStudyDate;
    final lastDay = last == null ? null : DateTime(last.year, last.month, last.day);

    var newStreak = currentUser.streak;
    var newLastStudyDate = now;

    if (lastDay == null) {
      newStreak = 1;
    } else {
      final dayDifference = today.difference(lastDay).inDays;
      if (dayDifference == 1) {
        newStreak += 1;
      } else if (dayDifference > 1) {
        newStreak = 1;
      } else if (dayDifference < 0) {
        // Device date moved backwards: do not rewind the saved study date.
        newLastStudyDate = last!;
      }
      // dayDifference == 0 means another lesson on the same calendar day.
    }

    final safeXpGain = xpGain < 0 ? 0 : xpGain;
    final safeCoinGain = coinGain < 0 ? 0 : coinGain;
    _user = currentUser.copyWith(
      completedLessonIds: ids,
      xp: currentUser.xp + safeXpGain,
      coins: currentUser.coins + safeCoinGain,
      streak: newStreak,
      longestStreak: newStreak > currentUser.longestStreak
          ? newStreak
          : currentUser.longestStreak,
      lastStudyDate: newLastStudyDate,
    );
    await _save();
  }

  // ── Spaced vocabulary review ───────────────────────────────────────
  String _vocabularyKey(String word) => word.trim().toLowerCase();

  bool isVocabularyDue(String word, {DateTime? at}) {
    final dueValue = _user?.vocabularyReviewDueDates[_vocabularyKey(word)];
    if (dueValue == null) return true;
    final due = DateTime.tryParse(dueValue);
    if (due == null) return true;
    final now = at ?? DateTime.now();
    return !DateTime(due.year, due.month, due.day).isAfter(
      DateTime(now.year, now.month, now.day),
    );
  }

  Future<void> reviewVocabulary(String word, {required bool remembered}) async {
    final current = _user;
    if (current == null || word.trim().isEmpty) return;
    final key = _vocabularyKey(word);
    final repetitions = Map<String, int>.from(current.vocabularyReviewRepetitions);
    final intervals = Map<String, int>.from(current.vocabularyReviewIntervals);
    final dueDates = Map<String, String>.from(current.vocabularyReviewDueDates);

    final nextRepetition = remembered ? (repetitions[key] ?? 0) + 1 : 0;
    final previousInterval = intervals[key] ?? 0;
    final nextInterval = !remembered
        ? 1
        : nextRepetition == 1
            ? 1
            : nextRepetition == 2
                ? 3
                : (previousInterval * 2).clamp(1, 180).toInt();

    final now = DateTime.now();
    final due = DateTime(now.year, now.month, now.day)
        .add(Duration(days: nextInterval));
    repetitions[key] = nextRepetition;
    intervals[key] = nextInterval;
    dueDates[key] = due.toIso8601String();

    _user = current.copyWith(
      vocabularyReviewRepetitions: repetitions,
      vocabularyReviewIntervals: intervals,
      vocabularyReviewDueDates: dueDates,
    );
    await _save();
  }

  // ── Dark Mode ─────────────────────────────────────────────────────
  Future<void> toggleDarkMode() async {
    if (_user == null) return;
    _user = _user!.copyWith(isDarkMode: !_user!.isDarkMode);
    await _save();
  }

  // ── Reset ─────────────────────────────────────────────────────────
  Future<void> reset() async {
    await StorageService.instance.clearUser();
    _user = null;
    notifyListeners();
  }

  // ── Private ───────────────────────────────────────────────────────
  Future<void> _save() async {
    if (_user != null) await StorageService.instance.saveUser(_user!);
    notifyListeners();
  }
}
