import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data.dart';

@LazySingleton()
class AppPreferences with LogMixin {
  AppPreferences(this._sharedPreference, this._secureStorage);

  final SharedPreferences _sharedPreference;
  final FlutterSecureStorage _secureStorage;

  // ======================
  // Non-sensitive values
  // ======================

  bool get isDarkMode =>
      _sharedPreference.getBool(SharedPreferenceKeys.isDarkMode) ?? false;

  String get deviceToken =>
      _sharedPreference.getString(SharedPreferenceKeys.deviceToken) ?? '';

  String get languageCode =>
      _sharedPreference.getString(SharedPreferenceKeys.languageCode) ?? '';

  bool get isFirstLogin =>
      _sharedPreference.getBool(SharedPreferenceKeys.isFirstLogin) ?? true;

  bool get isFirstLaunchApp =>
      _sharedPreference.getBool(SharedPreferenceKeys.isFirstLaunchApp) ?? true;

  // ======================
  // Sensitive values
  // ======================

  Future<String?> get accessToken =>
      _secureStorage.read(key: SharedPreferenceKeys.accessToken);

  Future<String?> get refreshToken =>
      _secureStorage.read(key: SharedPreferenceKeys.refreshToken);

  /// FIXED: now checks secure storage instead of shared prefs
  Future<bool> get isLoggedIn async {
    final token = await accessToken;
    return token != null && token.isNotEmpty;
  }

  // ======================
  // User
  // ======================

  PreferenceUserData? get currentUser {
    final user = _sharedPreference.getString(SharedPreferenceKeys.currentUser);
    if (user == null) return null;

    return PreferenceUserData.fromJson(json.decode(user));
  }

  // ======================
  // Save methods
  // ======================

  Future<bool> saveLanguageCode(String languageCode) {
    return _sharedPreference.setString(
      SharedPreferenceKeys.languageCode,
      languageCode,
    );
  }

  Future<bool> saveIsFirstLogin(bool isFirstLogin) {
    return _sharedPreference.setBool(
      SharedPreferenceKeys.isFirstLogin,
      isFirstLogin,
    );
  }

  Future<bool> saveIsFirsLaunchApp(bool isFirstLaunchApp) {
    return _sharedPreference.setBool(
      SharedPreferenceKeys.isFirstLaunchApp,
      isFirstLaunchApp,
    );
  }

  Future<void> saveAccessToken(String token) {
    return _secureStorage.write(
      key: SharedPreferenceKeys.accessToken,
      value: token,
    );
  }

  Future<void> saveRefreshToken(String token) {
    return _secureStorage.write(
      key: SharedPreferenceKeys.refreshToken,
      value: token,
    );
  }

  Future<bool> saveCurrentUser(PreferenceUserData preferenceUserData) {
    return _sharedPreference.setString(
      SharedPreferenceKeys.currentUser,
      json.encode(preferenceUserData),
    );
  }

  Future<bool> saveIsDarkMode(bool isDarkMode) {
    return _sharedPreference.setBool(
      SharedPreferenceKeys.isDarkMode,
      isDarkMode,
    );
  }

  Future<bool> saveDeviceToken(String token) {
    return _sharedPreference.setString(
      SharedPreferenceKeys.deviceToken,
      token,
    );
  }

  // ======================
  // Clear
  // ======================

  Future<void> clearCurrentUserData() async {
    await Future.wait([
      _sharedPreference.remove(SharedPreferenceKeys.currentUser),
      _secureStorage.delete(key: SharedPreferenceKeys.accessToken),
      _secureStorage.delete(key: SharedPreferenceKeys.refreshToken),
    ]);
  }
}
