import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:triplan/src/forms/form_fields/user_selector.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/models/transaction.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/providers/group_providers.dart';
import 'package:triplan/src/providers/user_providers.dart';
import 'package:triplan/src/utils/api_tools.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';
import 'package:triplan/src/widgets/error_text.dart';
import 'package:triplan/src/widgets/transaction_form_user_item.dart';

class CreateTransactionForm extends ConsumerStatefulWidget {
  const CreateTransactionForm({required this.groupId, super.key});
  final String groupId;

  static const routeName = '/transaction/new';

  @override
  _CreateTransactionFormState createState() => _CreateTransactionFormState();
}

class _CreateTransactionFormState extends ConsumerState<CreateTransactionForm> {
  String? error;

  final _formKey = GlobalKey<FormState>();

  final _transactionTitle = TextEditingController();
  final _transactionCategory = TextEditingController();
  final _transactionAmount = TextEditingController();
  User? _payingUser;
  Map<User, TransactionTarget?>? _paidFor;

  @override
  Widget build(BuildContext context) {
    AsyncValue<Group> group = ref.watch(singleGroupProvider(widget.groupId));
    AsyncValue<User> currentUser = ref.watch(loggedInUserProvider);
    AsyncValue<List<User>> groupUsers =
        ref.watch(groupUsersProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: Column(
        children: [
          if (error != null)
            ErrorText(
              errorMessage: error!,
              toastMessage: "API ERROR",
            ),
          Form(
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
                groupUsers.toWidget((users) {
                  User? initialUserSelected;
                  currentUser.whenData((currentUser) {
                    if (users.contains(currentUser)) {
                      log("current user in group, defined as payer");
                      initialUserSelected = currentUser;
                      setState(() {
                        _payingUser = initialUserSelected;
                      });
                    } else {
                      log("current user not in group, no default payer");
                    }
                  });
                  return Column(
                    children: [
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("paid by"),
                          UserSelector(
                              users: users,
                              initialValue: initialUserSelected,
                              onChanged: (User? newValue) {
                                log("DEBUG user changed to $newValue");
                                setState(() {
                                  _payingUser = newValue!;
                                });
                              }),
                        ],
                      ),
                      const Divider(),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: ((context, index) {
                            final user = users[index];
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            List<TransactionTarget> paidFor = [];
            _paidFor?.forEach((k, v) => paidFor.add(v!));
            Transaction transaction = Transaction(
              id: "N/A",
              groupId: widget.groupId,
              paidBy: _payingUser!.id,
              paidFor: paidFor,
              amount: int.parse(_transactionAmount.text) * 100,
              date: DateTime.now(),
              category: _transactionCategory.text,
              title: _transactionTitle.text,
            );
            try {
              await _createTransaction(widget.groupId, transaction);
            } on ApiException catch (e) {
              setState(() {
                error = e.message;
              });
              return;
            }
            if (!mounted) return;
            Routemaster.of(context).pop();
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

  Future<User> _fetchUser(String userId) async {
    Future<User> response =
        fetchAndDecode('/users/$userId', (u) => User.fromJson(u));
    return response;
  }

  Future<List<User>> _fetchMultipleUsers(List<String> userIds) async {
    return await Future.wait(userIds.map((id) => _fetchUser(id)));
  }

  Future<Transaction> _createTransaction(
      String groupId, Transaction transaction) async {
    return createNew<Transaction>(
      '/groups/$groupId/transactions-error',
      transaction,
      Transaction.fromJson,
    );
  }
}
