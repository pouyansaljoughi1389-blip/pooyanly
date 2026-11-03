import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/local/storage_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  // ── Init ──────────────────────────────────────────────────────────
  Future<void> init() async {
    _user = StorageService.instance.loadUser();
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
  }) async {
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
    if (_user == null) return;
    final ids = List<String>.from(_user!.completedLessonIds);
    if (!ids.contains(lessonId)) ids.add(lessonId);

    final now = DateTime.now();
    final last = _user!.lastStudyDate;
    int newStreak = _user!.streak;

    if (last == null) {
      newStreak = 1;
    } else {
      final diff = now.difference(last).inDays;
      if (diff == 0) {
        // Same day — no change
      } else if (diff == 1) {
        newStreak += 1;
      } else {
        newStreak = 1; // Streak broken
      }
    }

    _user = _user!.copyWith(
      completedLessonIds: ids,
      xp: _user!.xp + xpGain,
      coins: _user!.coins + coinGain,
      streak: newStreak,
      longestStreak: newStreak > _user!.longestStreak ? newStreak : _user!.longestStreak,
      lastStudyDate: now,
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
