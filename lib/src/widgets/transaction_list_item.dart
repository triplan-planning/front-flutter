import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.category),
      leading: Hero(
        tag: "transaction_${transaction.id}",
        child: const Icon(Icons.payment),
      ),
      trailing: Text('${transaction.amount / 100}€'),
      subtitle: transaction.title == null
          ? Container()
          : Text('${transaction.title}'),
      onTap: () {
        context.goNamed(
          "transaction_detail",
          params: {
            "transaction_id": transaction.id,
          },
        );
      },
    );
  }
}
