import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/models/transaction.dart';
import 'package:triplan/src/providers/transaction_providers.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';
import 'package:triplan/src/widgets/transaction_list_item.dart';

class GroupDetailTransactionList extends ConsumerStatefulWidget {
  const GroupDetailTransactionList({required this.groupId, super.key});

  final String groupId;

  @override
  _GroupTransactionListState createState() => _GroupTransactionListState();
}

class _GroupTransactionListState
    extends ConsumerState<GroupDetailTransactionList> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Transaction>> transactions =
        ref.watch(transactionsForGroupProvider(widget.groupId));

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).goNamed(
            "new_transaction",
            params: {
              "group_id": widget.groupId,
            },
          );
          ref.refresh(transactionsForGroupProvider(widget.groupId));
        },
        child: const Icon(Icons.add),
      ),
      body: transactions.toWidget(
        (data) {
          if (data.isEmpty) {
            return const Center(child: Text("no transactions"));
          }
          return ListView.builder(
            restorationId: 'GroupDetailView',
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final transaction = data[index];
              return TransactionListItem(transaction: transaction);
            },
          );
        },
      ),
    );
  }
}
