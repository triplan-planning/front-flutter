import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/providers/preferences_providers.dart';
import 'package:triplan/src/utils/api_tools.dart';

final loggedInUserProvider = FutureProvider<User>((ref) async {
  final preferences = await ref.watch(preferencesProvider.future);

  String? currentUserId = preferences.getString("user_id");

  if (currentUserId == null || currentUserId.isEmpty) {
    return Future.error("not logged in");
  }

  return ref.watch(singleUserProvider(currentUserId).future);
});

final singleUserProvider = FutureProviderFamily<User, String>(
  ((ref, id) async {
    Future<User> response = fetchAndDecode(
      '/users/$id',
      (u) => User.fromJson(u),
    );
    return response;
  }),
);

final allUsersProvider = FutureProvider<List<User>>(
  ((ref) async {
    Future<List<User>> response = fetchAndDecodeList(
      '/users/',
      (l) => l.map((e) => User.fromJson(e)).toList(),
    );
    return response;
  }),
);

final multipleUserProvider = FutureProviderFamily<List<User>, List<String>>(
  ((ref, ids) async {
    return await Future.wait(ids
        .map(
          (id) => fetchAndDecode("/users/$id", (u) => User.fromJson(u)),
        )
        .toList());
  }),
);

final groupUsersProvider =
    FutureProviderFamily<List<User>, String>((ref, groupId) async {
  Future<List<User>> response = fetchAndDecodeList(
    "/groups/$groupId/users",
    (l) => l.map((e) => User.fromJson(e)).toList(),
  );
  return response;
});
