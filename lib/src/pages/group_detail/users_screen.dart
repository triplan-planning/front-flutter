import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/models/balance.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/providers/balances_providers.dart';
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
    AsyncValue<BalanceMap> balances =
        ref.watch(balancesForGroupProvider(widget.groupId));

    return Scaffold(
      body: users.toWidget(
        (usersData) {
          if (usersData.isEmpty) {
            return const Center(child: Text("no transactions"));
          }
          return ListView.builder(
            restorationId: 'GroupDetailView',
            itemCount: usersData.length,
            itemBuilder: (BuildContext context, int index) {
              final user = usersData[index];
              return balances.toWidget(
                (balancesData) {
                  final balance = balancesData.map[user.id]!;
                  final totalAmount = balance.totalAmount / 100;

                  return BalanceAmount(
                    payerName: user.name,
                    amount: totalAmount,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class BalanceAmount extends StatelessWidget {
  const BalanceAmount(
      {required this.payerName, required this.amount, super.key});
  final double amount;
  final String payerName;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(color: Colors.white);

    if (amount < 0) {
      textStyle = const TextStyle(color: Colors.red);
    } else if (amount > 0) {
      textStyle = const TextStyle(color: Colors.green);
    }

    return ListTile(
      title: Text(payerName),
      trailing: Text(
        '$amount €',
        style: textStyle,
      ),
    );
  }
}
