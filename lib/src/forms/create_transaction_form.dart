import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:triplan/src/forms/form_fields/user_selector.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/models/transaction.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/settings/settings_controller.dart';
import 'package:triplan/src/utils/api_tools.dart';

class CreateTransactionForm extends StatefulWidget {
  const CreateTransactionForm({required this.group, super.key});

  final Group group;
  static const routeName = '/transaction/new';

  @override
  State<CreateTransactionForm> createState() => _CreateTransactionFormState();
}

class _CreateTransactionFormState extends State<CreateTransactionForm> {
  final _formKey = GlobalKey<FormState>();

  final _transactionTitle = TextEditingController();
  final _transactionCategory = TextEditingController();
  final _transactionAmount = TextEditingController();
  User? _payingUser;

  @override
  Widget build(BuildContext context) {
    String currentUserId = SettingsController.of(context).userId ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                autofocus: true,
                decoration: const InputDecoration(labelText: 'title'),
                controller: _transactionTitle,
              ),
              TextFormField(
                autofocus: true,
                decoration: const InputDecoration(labelText: 'category'),
                controller: _transactionCategory,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'amount'),
                controller: _transactionAmount,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              UserSelector(
                  userIds: widget.group.userIds,
                  onChanged: (User? newValue) {
                    setState(() {
                      _payingUser = newValue!;
                    });
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            Transaction transaction = Transaction(
              id: "N/A",
              groupId: widget.group.id,
              paidBy: _payingUser!.id,
              paidFor: [TransactionTarget(userId: currentUserId, weight: 2)],
              amount: int.parse(_transactionAmount.text) * 100,
              date: DateTime.now(),
              category: _transactionCategory.text,
              title: _transactionTitle.text,
            );
            await createTransaction(widget.group.id, transaction);
            if (!mounted) return;
            Navigator.of(context).pop();
          }
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check),
        label: const Text("Create Transaction"),
      ),
    );
  }
}

Future<Transaction> createTransaction(
    String groupId, Transaction transaction) async {
  return createNew<Transaction>(
    '/groups/$groupId/transactions',
    transaction,
    Transaction.fromJson,
  );
}
