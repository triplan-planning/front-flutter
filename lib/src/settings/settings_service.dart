import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  final prefs = SharedPreferences.getInstance();

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async =>
      ThemeMode.values[(await prefs).getInt("theme") ?? 0];
  Future<bool> devMode() async => (await prefs).getBool("dev_mode") ?? false;
  Future<String?> userId() async => (await prefs).getString("user_id");

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    await (await prefs).setInt("theme", theme.index);
  }

  Future<void> updateDevMode(bool devMode) async {
    await (await prefs).setBool("dev_mode", devMode);
  }

  Future<void> updateUserId(String? userId) async {
    if (userId == null) {
      await (await prefs).remove("user_id");
      return;
    }
    await (await prefs).setString("user_id", userId);
  }
}
