import 'package:flutter/material.dart';

import 'settings_service.dart';

class SettingsProvider extends InheritedWidget {
  const SettingsProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  final SettingsController controller;

  @override
  bool updateShouldNotify(covariant SettingsProvider oldWidget) {
    return oldWidget.controller != controller;
  }
}

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  static SettingsController of(BuildContext context) {
    final SettingsProvider? result =
        context.dependOnInheritedWidgetOfExactType<SettingsProvider>();
    assert(result != null, 'No SettingsProvider found in context');
    return result!.controller;
  }

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  late bool _devMode;
  late String? _userId;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;
  bool get devMode => _devMode;
  String? get userId => _userId;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _devMode = await _settingsService.devMode();
    _userId = await _settingsService.userId();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateDevMode(bool? newDevMode) async {
    if (newDevMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newDevMode == _devMode) return;

    // Otherwise, store the new ThemeMode in memory
    _devMode = newDevMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateDevMode(newDevMode);
  }

  Future<void> updateUserId(String? newUserId) async {
    // Do not perform any work if new and old ThemeMode are identical
    if (newUserId == _userId) return;

    // Otherwise, store the new ThemeMode in memory
    _userId = newUserId;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateUserId(newUserId);
  }
}
