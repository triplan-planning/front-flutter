import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:triplan/src/forms/form_fields/user_selector.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/models/transaction.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/settings/settings_controller.dart';
import 'package:triplan/src/utils/api_tools.dart';
import 'package:triplan/src/widgets/transaction_form_user_item.dart';

class CreateTransactionForm extends StatefulWidget {
  const CreateTransactionForm({required this.group, super.key});

  final Group group;
  static const routeName = '/transaction/new';

  @override
  State<CreateTransactionForm> createState() => _CreateTransactionFormState();
}

class _CreateTransactionFormState extends State<CreateTransactionForm> {
  late Future<List<User>> groupUsers;

  final _formKey = GlobalKey<FormState>();

  final _transactionTitle = TextEditingController();
  final _transactionCategory = TextEditingController();
  final _transactionAmount = TextEditingController();
  User? _payingUser;
  Map<User, TransactionTarget?>? _paidFor;

  @override
  void initState() {
    super.initState();
    groupUsers = fetchMultipleUsers(widget.group.userIds).then((users) {
      _paidFor = {for (var u in users) u: null};
      return users;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentUserId = SettingsController.of(context).userId ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
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
              decoration: const InputDecoration(hintText: 'amount'),
              controller: _transactionAmount,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                return null;
              },
            ),
            FutureBuilder<List<User>>(
                future: groupUsers,
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  if (snapshot.error != null) {
                    return ErrorWidget(snapshot.error!);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (data.isEmpty) {
                    return const Center(child: Text("no data"));
                  }
                  return Column(
                    children: [
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("paid by"),
                          UserSelector(
                              users: data,
                              onChanged: (User? newValue) {
                                setState(() {
                                  _payingUser = newValue!;
                                });
                              }),
                        ],
                      ),
                      const Divider(),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: ((context, index) {
                            final user = data[index];
                            return TransactionFormUserItem(
                              user: user,
                              onChanged:
                                  (Map<User, TransactionTarget?>? newValue) {
                                setState(() {
                                  _paidFor = {..._paidFor!, ...newValue!};
                                });
                              },
                            );
                          }))
                    ],
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            List<TransactionTarget> paidFor = [];
            _paidFor?.forEach((k, v) => paidFor.add(v!));
            Transaction transaction = Transaction(
              id: "N/A",
              groupId: widget.group.id,
              paidBy: _payingUser!.id,
              paidFor: paidFor,
              amount: int.parse(_transactionAmount.text) * 100,
              date: DateTime.now(),
              category: _transactionCategory.text,
              title: _transactionTitle.text,
            );
            await createTransaction(widget.group.id, transaction);
            if (!mounted) return;
            Navigator.pop(context, true);
          } else {
            log("form not valid, please handle");
          }
        },
        backgroundColor: Colors.green,
        icon: const Icon(Icons.check),
        label: const Text("Create Transaction"),
      ),
    );
  }
}

Future<User> fetchUser(String userId) async {
  Future<User> response =
      fetchAndDecode('/users/$userId', (u) => User.fromJson(u));
  return response;
}

Future<List<User>> fetchMultipleUsers(List<String> userIds) async {
  return await Future.wait(userIds.map((id) => fetchUser(id)));
}

Future<Transaction> createTransaction(
    String groupId, Transaction transaction) async {
  return createNew<Transaction>(
    '/groups/$groupId/transactions',
    transaction,
    Transaction.fromJson,
  );
}
