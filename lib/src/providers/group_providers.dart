import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/group.dart';
import '../utils/api_tools.dart';

final singleGroupProvider = FutureProviderFamily<Group, String>(
  ((ref, id) async {
    Future<Group> response = fetchAndDecode(
      '/groups/$id',
      (u) => Group.fromJson(u),
    );
    return response;
  }),
);

final allGroupsProvider = FutureProvider<List<Group>>(
  ((ref) async {
    Future<List<Group>> response = fetchAndDecodeList(
      '/groups/',
      (l) => l.map((e) => Group.fromJson(e)).toList(),
    );
    return response;
  }),
);
