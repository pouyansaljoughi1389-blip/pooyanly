import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const _keyUser    = 'pouyanly_user';
  static const _keyDark    = 'pouyanly_dark';

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

  // ── Dark Mode ────────────────────────────────────────────────────
  bool get isDarkMode => _prefs.getBool(_keyDark) ?? false;

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_keyDark, value);
  }
}
