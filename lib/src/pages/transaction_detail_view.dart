import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/models/transaction.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/providers/group_providers.dart';
import 'package:triplan/src/providers/transaction_providers.dart';
import 'package:triplan/src/providers/user_providers.dart';
import 'package:triplan/src/utils/date_utils.dart';
import 'package:triplan/src/utils/layout_utils.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';
import 'package:triplan/src/widgets/buttons.dart';

/// Displays detailed information about a Transaction.
class TransactionDetailView extends ConsumerStatefulWidget {
  const TransactionDetailView({required this.transactionId, super.key});

  final String transactionId;

  @override
  _TransactionDetailViewState createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends ConsumerState<TransactionDetailView> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<Transaction> transactionValue =
        ref.watch(singleTransactionProvider(widget.transactionId));

    AsyncValue<Group> groupValue = const AsyncValue.loading();
    AsyncValue<List<User>> groupUsersValue = const AsyncValue.loading();
    User? payer;

    transactionValue.whenData((transaction) {
      groupValue = ref.watch(singleGroupProvider(transaction.groupId));
      groupUsersValue = ref.watch(groupUsersProvider(transaction.groupId));

      groupUsersValue.whenData((groupUsers) {
        payer = groupUsers.firstWhereOrNull((u) => u.id == transaction.paidBy);
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: transactionValue.toWidgetDataOnly((transaction) =>
            PopOrNavigateToNamedLocationButton(
              locationName: "groups_detail",
              params: {"group_id": transaction.groupId},
              onButtonPressed: () {
                log("refreshing transaction and going back");
                return ref.refresh(singleGroupProvider(transaction.groupId));
              },
            )),
        title: transactionValue.toWidgetDataOnly(
          (transaction) => Text(transaction.title ??
              "${transaction.category} (${transaction.id})"),
        ),
        actions: [
          IconButton(
            tooltip: "edit this transaction",
            icon: const Icon(Icons.edit),
            onPressed: () {
              var snackBar = const SnackBar(
                content: Text('This feature is not implemented yet'),
                backgroundColor: Colors.amber,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
      body: transactionValue.toWidgetDataOnly(
        (transaction) => GlobalWidthWrapper(
          child: TransactionDetailBody(
            groupValue: groupValue,
            payer: payer,
            groupUsersValue: groupUsersValue,
            transaction: transaction,
          ),
        ),
      ),
    );
  }
}

class TransactionDetailBody extends StatelessWidget {
  const TransactionDetailBody({
    super.key,
    required this.groupValue,
    required this.payer,
    required this.groupUsersValue,
    required this.transaction,
  });

  final AsyncValue<Group> groupValue;
  final User? payer;
  final AsyncValue<List<User>> groupUsersValue;
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        groupValue.toWidgetWithLoading(
          (group) => ListTile(
            leading: const Icon(Icons.group),
            title: Text(group.name),
          ),
          loadingWidget: ListTile(
            leading: const Icon(Icons.group),
            title: Text(transaction.groupId),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title: Text(transaction.category),
        ),
        if (transaction.title != null)
          ListTile(
            leading: const Icon(Icons.title),
            title: Text(transaction.title!),
          ),
        ListTile(
          leading: const Icon(Icons.date_range),
          title: Text(dateTimeFormat.format(transaction.date)),
        ),
        ListTile(
          leading: const Icon(Icons.money),
          title: Text("${transaction.amount / 100}€"),
        ),
        ListTile(
          leading: const Icon(Icons.paid),
          title: Text(payer?.name ?? transaction.paidBy),
          trailing: Text("${transaction.amount / 100}€"),
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: transaction.paidFor.length,
          itemBuilder: (context, index) {
            final TransactionTarget target = transaction.paidFor[index];
            User? payee;
            groupUsersValue.whenData((groupUsers) {
              payee = groupUsers.firstWhereOrNull((u) {
                return u.id == target.userId;
              });
            });
            num amount = (target.computedPrice ?? 0) / 100;
            return ListTile(
              leading: const Icon(Icons.person),
              title: Text(payee?.name ?? target.userId),
              subtitle: (target.weight != null && target.weight != 1)
                  ? Text("weight : ${target.weight! * 100}%")
                  : null,
              trailing: Text("$amount€"),
            );
          },
        )
      ],
    );
  }
}
