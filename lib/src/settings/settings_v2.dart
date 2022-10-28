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
  final String? favoriteGroup;

  const PreferencesState({
    required this.devMode,
    required this.themeMode,
    this.userId,
    this.favoriteGroup,
  });

  factory PreferencesState.fromDefault() {
    return const PreferencesState(
      devMode: false,
      themeMode: ThemeMode.system,
      userId: null,
      favoriteGroup: null,
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
      favoriteGroup:
          pref.getString("favorite_group_id") ?? defaultState.favoriteGroup,
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
  setThemeMode(ThemeMode theme) {
    checkReadiness();
    log("[SETTINGS] update theme to ${theme.name}");
    pref!.setInt("theme", theme.index);
    state = PreferencesState.fromSharedPrefs(pref!);
  }

  // DEV MODE
  bool get devMode => state.devMode;
  setDevMode(bool devMode) {
    checkReadiness();
    log("[SETTINGS] update dev mode to $devMode");
    pref!.setBool("dev_mode", devMode);
    state = PreferencesState.fromSharedPrefs(pref!);
  }

  // USER ID
  String? get userId => state.userId;
  setUserId(String? userId) {
    checkReadiness();
    log("[SETTINGS] update userID to $userId");

    if (userId == null) {
      pref!.remove("user_id");
    } else {
      pref!.setString("user_id", userId);
    }
    state = PreferencesState.fromSharedPrefs(pref!);
  }

  // FAVORITE GROUP
  String? get favoriteGroup => state.favoriteGroup;
  setFavoriteGroup(String? favoriteGroup) {
    checkReadiness();
    log("[SETTINGS] update favorite group to $favoriteGroup");

    if (favoriteGroup == null) {
      pref!.remove("favorite_group_id");
    } else {
      pref!.setString("favorite_group_id", favoriteGroup);
    }
    state = PreferencesState.fromSharedPrefs(pref!);
  }
}
