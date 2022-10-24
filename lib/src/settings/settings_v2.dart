import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triplan/src/providers/preferences_providers.dart';

final triplanPreferencesProvider =
    StateNotifierProvider<TriplanPreferencesNotifier, PreferencesState>((ref) {
  return TriplanPreferencesNotifier(ref);
});

@immutable
class PreferencesState {
  final bool devMode;
  final String? userId;
  final ThemeMode themeMode;

  const PreferencesState({
    required this.devMode,
    required this.themeMode,
    this.userId,
  });

  factory PreferencesState.fromDefault() {
    return const PreferencesState(
      devMode: false,
      themeMode: ThemeMode.system,
      userId: null,
    );
  }

  /// Load preferences object from stored shared preferences, this is where the state is initialized
  factory PreferencesState.fromSharedPrefs(SharedPreferences pref) {
    PreferencesState defaultState = PreferencesState.fromDefault();

    return PreferencesState(
      devMode: pref.getBool("dev_mode") ?? defaultState.devMode,
      themeMode: ThemeMode
          .values[pref.getInt("theme") ?? defaultState.themeMode.index],
      userId: pref.getString("user_id") ?? defaultState.userId,
    );
  }

  PreferencesState copyWith({
    bool? devMode,
    ThemeMode? themeMode,
    String? userId,
  }) {
    return PreferencesState(
      devMode: devMode ?? this.devMode,
      themeMode: themeMode ?? this.themeMode,
      userId: userId ?? this.userId,
    );
  }
}

class TriplanPreferencesNotifier extends StateNotifier<PreferencesState> {
  final Ref ref;
  bool ready = false;
  SharedPreferences? pref;

  TriplanPreferencesNotifier(this.ref) : super(PreferencesState.fromDefault()) {
    SharedPreferences? prefValue =
        ref.watch(preferencesProvider).whenData((value) => value).value;

    if (prefValue == null) {
      log("[SETTINGS] loading...");
    } else {
      pref = prefValue;
      state = PreferencesState.fromSharedPrefs(prefValue);
      ready = true;
      log("[SETTINGS] preferences loaded");
    }
  }

  checkReadiness() {
    if (!ready) {
      throw Exception("[SETTINGS] Settings not ready");
    }
  }

  // THEME
  ThemeMode get themeMode => state.themeMode;
  setThemeMode(ThemeMode? theme) {
    checkReadiness();
    if (theme == null) {
      log("[SETTINGS] null value provided for theme, not updating");
      return;
    }
    log("[SETTINGS] update theme to ${theme.name}");
    state = state.copyWith(themeMode: theme);
    pref!.setInt("theme", state.themeMode.index);
  }

  // DEV MODE
  bool get devMode => state.devMode;
  setDevMode(bool? devMode) {
    checkReadiness();
    if (devMode == null) {
      log("[SETTINGS] null value provided for dev mode, not updating");
      return;
    }
    log("[SETTINGS] update dev mode to $devMode");
    state = state.copyWith(devMode: devMode);
    pref!.setBool("dev_mode", state.devMode);
  }

  // USER ID
  String? get userId => state.userId;
  setUserId(String? userId) {
    checkReadiness();
    log("[SETTINGS] update userID to $userId");

    if (userId == null) {
      pref!.remove("user_id");
    } else {
      state = state.copyWith(userId: userId);
      pref!.setString("user_id", state.userId!);
    }
  }
}
