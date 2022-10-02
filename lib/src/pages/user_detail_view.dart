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
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Hero(
                tag: "user_${user.id}",
                child: const Icon(Icons.person),
              ),
            ),
            const Text('User Details'),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                /**
                 * store the navigator before the async call to avoid using the context after an async gap.
                 * an other way is to use a stateful widget and to check if the widget is still mounted
                 */
                var navigator = Navigator.of(context);
                await _deleteUser(context);
                if (!navigator.mounted) return;
                navigator.pop();
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
    return deleteEntity('/users/${user.id}');
  }
}
