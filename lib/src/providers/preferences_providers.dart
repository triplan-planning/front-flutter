import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  final preferences = await SharedPreferences.getInstance();
  return preferences;
});
