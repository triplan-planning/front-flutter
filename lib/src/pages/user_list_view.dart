import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/providers/user_providers.dart';
import 'package:triplan/src/utils/api_tools.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';

class UserListView extends ConsumerStatefulWidget {
  const UserListView({
    Key? key,
    this.onPick,
    this.enableUserCreation = false,
  }) : super(key: key);

  final Function(User)? onPick;
  final bool enableUserCreation;

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends ConsumerState<UserListView> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<User>> users = ref.watch(allUsersProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed("users_new");
          ref.refresh(allUsersProvider);
        },
        child: const Icon(Icons.add),
      ),
      body: users.toWidget((value) => ListView.builder(
            restorationId: 'UserListView',
            itemCount: value.length,
            itemBuilder: (BuildContext context, int index) {
              final user = value[index];

              return ListTile(
                  title: Text('user: ${user.name}'),
                  leading: Hero(
                    tag: "user_${user.id}",
                    child: const Icon(Icons.person),
                  ),
                  onTap: () {
                    if (widget.onPick != null) {
                      widget.onPick!(user);
                    }
                    if (widget.enableUserCreation) {
                      GoRouter.of(context).push("users/${user.id}");
                      ref.refresh(allUsersProvider);
                    }
                  });
            },
          )),
    );
  }

  Future<List<User>> fetchUsers() async {
    Future<List<User>> response = fetchAndDecodeList(
        '/users', (l) => l.map((e) => User.fromJson(e)).toList());
    return response;
  }
}
