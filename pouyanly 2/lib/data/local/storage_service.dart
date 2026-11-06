import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const _keyUser    = 'pouyanly_user';
  static const _keyDark    = 'pouyanly_dark';
  static const _keyAssessmentHistory = 'pouyanly_assessment_history';
  static const _keyDailyMissions = 'pouyanly_daily_missions';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── User ────────────────────────────────────────────────────────
  UserModel? loadUser() {
    final raw = _prefs.getString(_keyUser);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  Future<void> clearUser() async {
    await _prefs.remove(_keyUser);
  }

  // ── Placement assessment history ────────────────────────────────
  List<Map<String, dynamic>> loadAssessmentHistory() {
    final raw = _prefs.getString(_keyAssessmentHistory);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> appendAssessment(Map<String, dynamic> snapshot) async {
    final history = loadAssessmentHistory()..add(snapshot);
    await _prefs.setString(_keyAssessmentHistory, jsonEncode(history));
  }

  // ── Dark Mode ────────────────────────────────────────────────────
  bool get isDarkMode => _prefs.getBool(_keyDark) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyDark, value);
  }
}
