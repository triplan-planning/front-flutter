import 'package:flutter/material.dart';
import 'package:triplan/src/forms/create_transaction_form.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/models/transaction.dart';
import 'package:triplan/src/utils/api_tools.dart';
import 'package:triplan/src/widgets/transaction_list_item.dart';

/// Displays detailed information about a User.
class GroupDetailView extends StatefulWidget {
  const GroupDetailView({required this.group, super.key});

  final Group group;
  static const routeName = '/group';

  @override
  State<GroupDetailView> createState() => _GroupDetailViewState();
}

class _GroupDetailViewState extends State<GroupDetailView> {
  late Future<List<Transaction>> futureTransactions;

  @override
  void initState() {
    super.initState();
    futureTransactions = fetchTransactionsByGroupId(widget.group.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateTransactionForm.routeName,
              arguments: widget.group);
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Group Details'),
      ),
      body: Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        direction: Axis.vertical,
        children: [
          Text('name: ${widget.group.name}'),
          Text('id: ${widget.group.id}'),
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: futureTransactions,
              builder: ((context, snapshot) {
                var data = snapshot.data;
                if (snapshot.error != null) {
                  return ErrorWidget(snapshot.error!);
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  restorationId: 'GroupDetailView',
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final transaction = data[index];

                    return TransactionListItem(transaction: transaction);
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Future<List<Transaction>> fetchTransactionsByGroupId(String groupId) async {
    Future<List<Transaction>> response = fetchAndDecodeList(
        '/groups/$groupId/transactions',
        (l) => l.map((e) => Transaction.fromJson(e)).toList());
    return response;
  }
}
