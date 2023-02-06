import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/group.dart';
import '../utils/api_tools.dart';

final singleGroupProvider = FutureProviderFamily<Group, String?>(
  (ref, id) async {
    if (id == null) {
      log("[PROVIDER] no id provided for group, no data fetched from API");
      return Future.error("no id passed");
    }

    Future<Group> response = fetchAndDecode(
      '/groups/$id',
      (u) => Group.fromJson(u),
    );
    return response;
  },
);

final allGroupsProvider = FutureProvider<List<Group>>(
  (ref) async {
    Future<List<Group>> response = fetchAndDecodeList(
      '/groups',
      (l) => l.map((e) => Group.fromJson(e)).toList(),
    );
    return response;
  },
);
