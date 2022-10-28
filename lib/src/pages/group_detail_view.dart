import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/models/transaction.dart';
import 'package:triplan/src/providers/group_providers.dart';
import 'package:triplan/src/providers/transaction_providers.dart';
import 'package:triplan/src/settings/settings_v2.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';
import 'package:triplan/src/widgets/buttons.dart';
import 'package:triplan/src/widgets/transaction_list_item.dart';

/// Displays detailed information about a User.
class GroupDetailView extends ConsumerStatefulWidget {
  const GroupDetailView({required this.groupId, super.key});

  final String groupId;

  @override
  _GroupDetailViewState createState() => _GroupDetailViewState();
}

class _GroupDetailViewState extends ConsumerState<GroupDetailView> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<Group> group = ref.watch(singleGroupProvider(widget.groupId));
    AsyncValue<List<Transaction>> transactions =
        ref.watch(transactionsForGroupProvider(widget.groupId));

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: group.toWidgetDataOnly(
        (value) => FloatingActionButton(
          onPressed: () {
            GoRouter.of(context)
                .push("/groups/${widget.groupId}/transactions/new");
            ref.refresh(transactionsForGroupProvider(widget.groupId));
          },
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        leading: const PopOrBackToListButton(),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Hero(
                tag: "group_${widget.groupId}",
                child: const Icon(Icons.flight),
              ),
            ),
            group.toWidgetDataOnly(
              (value) => Text('Group : ${value.name}'),
            ),
          ],
        ),
        actions: [FavoriteGroupButton(groupId: widget.groupId)],
      ),
      body: Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        direction: Axis.vertical,
        children: [
          Expanded(child: transactions.toWidget(
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
          )),
          if (ref.read(triplanPreferencesProvider).devMode)
            group.toWidgetDataOnly((value) => Text('id: ${value.id}')),
        ],
      ),
    );
  }
}
