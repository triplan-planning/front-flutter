import 'package:flutter/material.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/utils/api_tools.dart';

/// Displays detailed information about a User.
class UserDetailView extends StatelessWidget {
  const UserDetailView({required this.user, super.key});

  final User user;
  static const routeName = '/user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          IconButton(
              onPressed: () {
                _deleteUser(context);
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
              ))
        ],
      ),
      body: Center(
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.vertical,
          children: [
            Text('name: ${user.name}'),
            Text('id: ${user.id}'),
          ],
        ),
      ),
    );
  }

  _deleteUser(BuildContext context) async {
    deleteEntity('users/${user.id}');
    Navigator.of(context).pop();
  }
}
