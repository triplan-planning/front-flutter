import 'package:flutter/material.dart';
import 'package:triplan/src/models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transaction.category),
      leading: const Icon(Icons.attach_money),
      trailing: Text('\$${transaction.amount / 100}€'),
      subtitle: Text('${transaction.title}'),
    );
  }
}
