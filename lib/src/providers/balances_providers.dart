import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/models/balance.dart';
import 'package:triplan/src/utils/api_tools.dart';

final balancesForGroupProvider =
    FutureProviderFamily<BalanceMap, String>((ref, groupId) async {
  Future<BalanceMap> response = fetchAndDecode(
    '/groups/$groupId/balances',
    (e) => BalanceMap.fromJson(e),
  );

  return response;
});
