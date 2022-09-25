import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/utils/api_tools.dart';

final currentUserProvider = FutureProvider<User>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  String? currentUserId = prefs.getString("user_id");

  if (currentUserId == null || currentUserId.isEmpty) {
    return Future.error("not logged in");
  }

  try {
    return fetchAndDecode(
      '/users/$currentUserId',
      (u) => User.fromJson(u),
    );
  } catch (e) {
    return Future.error("unable to get user $currentUserId from API");
  }
});
