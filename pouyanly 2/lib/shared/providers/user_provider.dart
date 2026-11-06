import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/local/storage_service.dart';
import '../../features/lessons/models/lesson_data.dart';
import '../../core/services/daily_progress_widget_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  List<Map<String, dynamic>> _assessmentHistory = [];
  Map<String, dynamic> _dailyMissionState = {};
  Map<String, dynamic> _weeklyMissionState = {};

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String get _weekKey {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - DateTime.monday));
    return '${monday.year.toString().padLeft(4, '0')}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  bool _studiedToday(UserModel? value) {
    final date = value?.lastStudyDate;
    if (date == null) return false;
    return date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;
  }

  int get dailyLessonsCompleted => _dailyMissionState['date'] == _todayKey ? (_dailyMissionState['lessons'] as int? ?? 0) : 0;
  int get dailyXpEarned => _dailyMissionState['date'] == _todayKey ? (_dailyMissionState['xp'] as int? ?? 0) : 0;
  int get dailyProgressPercent => ((dailyXpEarned / 50) * 100).round().clamp(0, 100).toInt();

  Map<String, int> get dailyMissionProgress => {
    'lesson': _studiedToday(_user) ? 1 : 0,
    'vocabulary': _dailyMissionState['date'] == _todayKey
        ? (_dailyMissionState['vocabularyReviews'] as int? ?? 0)
        : 0,
    'streak': _studiedToday(_user) && (_user?.streak ?? 0) >= 2 ? 1 : 0,
  };

  Map<String, int> get weeklyMissionProgress {
    if (_weeklyMissionState['week'] != _weekKey) return {'lessons': 0, 'vocabulary': 0, 'studyDays': 0};
    return {
      'lessons': (_weeklyMissionState['lessons'] as List<dynamic>? ?? const []).length,
      'vocabulary': _weeklyMissionState['vocabularyReviews'] as int? ?? 0,
      'studyDays': (_weeklyMissionState['studyDays'] as List<dynamic>? ?? const []).length,
    };
  }

  Set<String> get claimedWeeklyMissions => _weeklyMissionState['week'] == _weekKey
      ? Set<String>.from(_weeklyMissionState['claimed'] ?? const <String>[])
      : <String>{};

  int get vocabularyMistakeCount {
    final mistakes = _user?.vocabularyReviewMistakes ?? const <String, int>{};
    return mistakes.values.fold<int>(0, (sum, count) => sum + count);
  }

  double get vocabularyMasteryPercent {
    final repetitions = _user?.vocabularyReviewRepetitions.values ?? const <int>[];
    if (repetitions.isEmpty) return 0;
    final score = repetitions.fold<int>(0, (sum, count) => sum + count.clamp(0, 5).toInt());
    return (score / (repetitions.length * 5) * 100).roundToDouble();
  }

  Set<String> get claimedDailyMissions =>
      _dailyMissionState['date'] == _todayKey
          ? Set<String>.from(_dailyMissionState['claimed'] ?? const <String>[])
          : <String>{};
  List<Map<String, dynamic>> get assessmentHistory => List.unmodifiable(_assessmentHistory);

  // ── Init ──────────────────────────────────────────────────────────
  Future<void> init() async {
    _user = StorageService.instance.loadUser();
    _assessmentHistory = StorageService.instance.loadAssessmentHistory();
    _dailyMissionState = StorageService.instance.loadDailyMissionState();
    _weeklyMissionState = StorageService.instance.loadWeeklyMissionState();
    _ensureDailyMissionDay();
    _ensureWeeklyMissionWeek();
    notifyListeners();
    try {
      await DailyProgressWidgetService.sync(lessons: dailyLessonsCompleted, xp: dailyXpEarned, percent: dailyProgressPercent);
    } catch (_) {}
  }

  // ── Create ────────────────────────────────────────────────────────
  Future<void> createUser({
    required String firstName,
    required String lastName,
    required String contact,
    required String contactType,
  }) async {
    final fullName = '$firstName $lastName'.trim();
    _user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: fullName,
      firstName: firstName,
      lastName: lastName,
      contact: contact,
      contactType: contactType,
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
    final reminderHour = switch (period) {
      StudyPeriod.earlyMorning => 7,
      StudyPeriod.morning => 9,
      StudyPeriod.afternoon => 15,
      StudyPeriod.evening => 19,
      StudyPeriod.night => 21,
    };
    try {
      await LearningReminderService.scheduleWeekly(
        time: TimeOfDay(hour: reminderHour, minute: 0),
        activeDays: {0, 1, 2, 3, 4, 5, 6},
      );
    } catch (_) {}
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

  // ── Daily missions ────────────────────────────────────────────────
  void _ensureDailyMissionDay() {
    if (_dailyMissionState['date'] != _todayKey) {
      _dailyMissionState = {
        'date': _todayKey,
        'vocabularyReviews': 0,
        'lessons': 0,
        'xp': 0,
        'claimed': <String>[],
      };
    }
  }

  void _ensureWeeklyMissionWeek() {
    if (_weeklyMissionState['week'] != _weekKey) {
      _weeklyMissionState = {
        'week': _weekKey,
        'lessons': <String>[],
        'vocabularyReviews': 0,
        'studyDays': <String>[],
        'claimed': <String>[],
      };
    }
  }

  Future<void> _recordWeeklyLesson(String lessonId, DateTime at) async {
    _ensureWeeklyMissionWeek();
    final lessons = List<String>.from(_weeklyMissionState['lessons'] ?? const <String>[]);
    if (!lessons.contains(lessonId)) lessons.add(lessonId);
    _weeklyMissionState['lessons'] = lessons;
    final day = '${at.year}-${at.month.toString().padLeft(2, '0')}-${at.day.toString().padLeft(2, '0')}';
    final studyDays = List<String>.from(_weeklyMissionState['studyDays'] ?? const <String>[]);
    if (!studyDays.contains(day)) studyDays.add(day);
    _weeklyMissionState['studyDays'] = studyDays;
    await StorageService.instance.saveWeeklyMissionState(_weeklyMissionState);
  }

  Future<void> _recordWeeklyVocabularyReview() async {
    _ensureWeeklyMissionWeek();
    _weeklyMissionState['vocabularyReviews'] =
        (_weeklyMissionState['vocabularyReviews'] as int? ?? 0) + 1;
    await StorageService.instance.saveWeeklyMissionState(_weeklyMissionState);
  }

  Future<bool> claimWeeklyMission(String missionId) async {
    if (_user == null) return false;
    _ensureWeeklyMissionWeek();
    const rewards = <String, ({int target, int xp, int coins})>{
      'lessons': (target: 3, xp: 60, coins: 15),
      'vocabulary': (target: 20, xp: 50, coins: 12),
      'studyDays': (target: 4, xp: 75, coins: 20),
    };
    final reward = rewards[missionId];
    if (reward == null || claimedWeeklyMissions.contains(missionId)) return false;
    if ((weeklyMissionProgress[missionId] ?? 0) < reward.target) return false;
    final claimed = List<String>.from(_weeklyMissionState['claimed'] ?? const <String>[])..add(missionId);
    _weeklyMissionState['claimed'] = claimed;
    _user = _user!.copyWith(xp: _user!.xp + reward.xp, coins: _user!.coins + reward.coins);
    await StorageService.instance.saveWeeklyMissionState(_weeklyMissionState);
    await _save();
    return true;
  }

  Future<void> _recordVocabularyMissionProgress() async {
    _ensureDailyMissionDay();
    final count = (_dailyMissionState['vocabularyReviews'] as int? ?? 0) + 1;
    _dailyMissionState['vocabularyReviews'] = count;
    await StorageService.instance.saveDailyMissionState(_dailyMissionState);
  }

  Future<bool> claimDailyMission(String missionId) async {
    if (_user == null) return false;
    _ensureDailyMissionDay();
    const rewards = <String, ({int target, int xp, int coins})>{
      'lesson': (target: 1, xp: 20, coins: 5),
      'vocabulary': (target: 5, xp: 15, coins: 3),
      'streak': (target: 1, xp: 10, coins: 2),
    };
    final reward = rewards[missionId];
    if (reward == null || claimedDailyMissions.contains(missionId)) return false;
    final progress = dailyMissionProgress[missionId] ?? 0;
    if (progress < reward.target) return false;

    final claimed = List<String>.from(_dailyMissionState['claimed'] ?? const <String>[])
      ..add(missionId);
    _dailyMissionState['claimed'] = claimed;
    _user = _user!.copyWith(
      xp: _user!.xp + reward.xp,
      coins: _user!.coins + reward.coins,
    );
    await StorageService.instance.saveDailyMissionState(_dailyMissionState);
    await _save();
    return true;
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

  // Skip only the next sequential lesson; skipping costs XP and grants no lesson reward.
  Future<bool> skipLesson(String lessonId, {int xpCost = 100, required List<String> previousLessonIds}) async {
    final current = _user;
    if (current == null || current.xp < xpCost || current.completedLessonIds.contains(lessonId)) return false;
    if (!CourseData.getAllUnits().expand((unit) => unit.lessons).any((lesson) => lesson.id == lessonId)) return false;
    if (previousLessonIds.any((id) => !current.completedLessonIds.contains(id))) return false;
    final completed = List<String>.from(current.completedLessonIds)..add(lessonId);
    _user = current.copyWith(xp: current.xp - xpCost, completedLessonIds: completed);
    await _save();
    return true;
  }

  Future<void> completeCheckpoint(String unitId) async {
    final current = _user;
    if (current == null || unitId.trim().isEmpty) return;
    final checkpointId = 'checkpoint_$unitId';
    if (current.completedLessonIds.contains(checkpointId)) return;
    _user = current.copyWith(
      completedLessonIds: [...current.completedLessonIds, checkpointId],
      xp: current.xp + 50,
      coins: current.coins + 10,
    );
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
    _ensureDailyMissionDay();
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
    _ensureDailyMissionDay();
    _dailyMissionState['lessons'] = (_dailyMissionState['lessons'] as int? ?? 0) + 1;
    _dailyMissionState['xp'] = (_dailyMissionState['xp'] as int? ?? 0) + safeXpGain;
    await StorageService.instance.saveDailyMissionState(_dailyMissionState);
    await _recordWeeklyLesson(lessonId, now);
    await _save();
    try {
      await DailyProgressWidgetService.sync(
        lessons: dailyLessonsCompleted,
        xp: dailyXpEarned,
        percent: dailyProgressPercent,
      );
    } catch (_) {}
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
    if (!remembered) {
      final mistakes = Map<String, int>.from(current.vocabularyReviewMistakes);
      mistakes[key] = (mistakes[key] ?? 0) + 1;
      _user = _user!.copyWith(vocabularyReviewMistakes: mistakes);
    }
    await _recordVocabularyMissionProgress();
    await _recordWeeklyVocabularyReview();
    await _save();
  }

  // ── Avatar ─────────────────────────────────────────────────────────
  static const Map<String, int> avatarUnlockCosts = {
    '🐼': 30, '🐯': 40, '🐸': 40, '🐧': 50,
    '🦉': 60, '🐙': 70, '🐨': 60,
  };

  Future<bool> unlockAvatarEmoji(String emoji) async {
    final current = _user;
    final cost = avatarUnlockCosts[emoji];
    if (current == null || cost == null) return false;
    if (current.unlockedAvatarEmojis.contains(emoji)) return true;
    if (current.coins < cost) return false;
    _user = current.copyWith(
      coins: current.coins - cost,
      unlockedAvatarEmojis: [...current.unlockedAvatarEmojis, emoji],
    );
    await _save();
    return true;
  }

  Future<void> setAvatarEmoji(String emoji) async {
    if (_user == null || !_user!.unlockedAvatarEmojis.contains(emoji)) return;
    _user = _user!.copyWith(avatarEmoji: emoji);
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
    if (_user != null) {
      await StorageService.instance.saveUser(_user!);
      await DailyProgressWidgetService.sync(
        lessons: dailyLessonsCompleted,
        xp: dailyXpEarned,
        percent: dailyProgressPercent,
      );
    }
    notifyListeners();
  }
}
