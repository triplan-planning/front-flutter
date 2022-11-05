import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/providers/user_providers.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';

class GroupDetailBalanceList extends ConsumerStatefulWidget {
  const GroupDetailBalanceList({required this.groupId, super.key});

  final String groupId;

  @override
  _GroupDetailBalanceListState createState() => _GroupDetailBalanceListState();
}

class _GroupDetailBalanceListState
    extends ConsumerState<GroupDetailBalanceList> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<User>> users =
        ref.watch(groupUsersProvider(widget.groupId));

    return Scaffold(
      body: users.toWidget(
        (data) {
          if (data.isEmpty) {
            return const Center(child: Text("no transactions"));
          }
          return ListView.builder(
            restorationId: 'GroupDetailView',
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final user = data[index];
              return ListTile(
                title: Text(user.name),
                trailing: const Text(
                  '\$0.00€',
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
