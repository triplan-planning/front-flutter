import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/providers/user_providers.dart';
import 'package:triplan/src/utils/api_tools.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';

/// Displays detailed information about a User.
class UserDetailView extends ConsumerStatefulWidget {
  const UserDetailView({required this.userId, this.user, super.key});

  final User? user;
  final String userId;
  static const routeName = '/users';

  @override
  _UserDetailViewState createState() => _UserDetailViewState();
}

class _UserDetailViewState extends ConsumerState<UserDetailView> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<User> user = ref.watch(singleUserProvider(widget.userId));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Hero(
                tag: "user_${widget.userId}",
                child: const Icon(Icons.person),
              ),
            ),
            user.toWidgetDataOnly(
              (value) => Text('User : ${value.name}'),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () async {
                /**
                 * store the navigator before the async call to avoid using the context after an async gap.
                 * an other way is to use a stateful widget and to check if the widget is still mounted
                 */
                var navigator = Routemaster.of(context);
                await _deleteUser(context);
                navigator.pop();
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
              ))
        ],
      ),
      body: Center(
        child: user.toWidget(
          (value) => Flex(
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.vertical,
            children: [
              Text('name: ${value.name}'),
              Text('id: ${value.id}'),
            ],
          ),
        ),
      ),
    );
  }

  _deleteUser(BuildContext context) async {
    return deleteEntity('/users/${widget.userId}');
  }
}
