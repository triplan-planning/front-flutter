import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/models/transaction.dart';
import 'package:triplan/src/utils/api_tools.dart';

final transactionsForGroupProvider =
    FutureProviderFamily<List<Transaction>, String>((ref, groupId) async {
  Future<List<Transaction>> response = fetchAndDecodeList(
    '/groups/$groupId/transactions',
    (l) => l.map((e) => Transaction.fromJson(e)).toList(),
  );
  return response;
});

final singleTransactionProvider =
    FutureProviderFamily<Transaction, String>((ref, transactionId) async {
  Future<Transaction> response = fetchAndDecode(
    '/transactions/$transactionId',
    (t) => Transaction.fromJson(t),
  );
  return response;
});
