import 'package:flutter/material.dart';
import 'package:triplan/src/forms/create_user_form.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/pages/user_detail_view.dart';
import 'package:triplan/src/utils/api_tools.dart';

class UserListView extends StatefulWidget {
  const UserListView({
    Key? key,
    this.onPick,
    this.enableUserCreation = false,
  }) : super(key: key);

  final Function(User)? onPick;
  final bool enableUserCreation;

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: widget.enableUserCreation
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  CreateUserForm.routeName,
                ).then(
                  (_) => setState(() {
                    futureUsers = fetchUsers();
                  }),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, snapshot) {
            var data = snapshot.data;
            if (snapshot.error != null) {
              return ErrorWidget(snapshot.error!);
            }
            if ((data == null || data.isEmpty) &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (data == null || data.isEmpty) {
              return ErrorWidget("no data");
            }
            return ListView.builder(
              restorationId: 'UserListView',
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final user = data[index];

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
                        Navigator.pushNamed(
                          context,
                          UserDetailView.routeName,
                          arguments: user,
                        ).then(
                          (value) => setState(() {
                            futureUsers = fetchUsers();
                          }),
                        );
                      }
                    });
              },
            );
          }),
    );
  }

  Future<List<User>> fetchUsers() async {
    Future<List<User>> response = fetchAndDecodeList(
        '/users', (l) => l.map((e) => User.fromJson(e)).toList());
    return response;
  }
}
