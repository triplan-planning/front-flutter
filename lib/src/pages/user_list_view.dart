import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triplan/src/forms/create_user_form.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/pages/user_detail_view.dart';

class UserListView extends StatefulWidget {
  const UserListView({
    Key? key,
  }) : super(key: key);

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
    // To work with lists that may contain a large number of items, it’s best
    // to use the ListView.builder constructor.
    //
    // In contrast to the default ListView constructor, which requires
    // building all Widgets up front, the ListView.builder constructor lazily
    // builds Widgets as they’re scrolled into view.
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateUserForm.routeName)
              .then((_) => setState(() {
                    futureUsers = fetchUsers();
                  }));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, snapshot) {
            var data = snapshot.data;
            if (snapshot.error != null) {
              return ErrorWidget(snapshot.error!);
            }
            if (snapshot.connectionState == ConnectionState.waiting ||
                data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'UserListView',
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final user = data[index];

                return ListTile(
                    title: Text('user: ${user.name}'),
                    leading: const Icon(Icons.person),
                    onTap: () {
                      // Navigate to the details page. If the user leaves and returns to
                      // the app after it has been killed while running in the
                      // background, the navigation stack is restored.
                      Navigator.pushNamed(context, UserDetailView.routeName,
                              arguments: user)
                          .then((value) => setState(() {
                                futureUsers = fetchUsers();
                              }));
                    });
              },
            );
          }),
    );
  }

  Future<List<User>> fetchUsers() async {
    final response = await http
        .get(Uri.parse('https://api-go-triplan.up.railway.app/users'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return List.of(jsonDecode(utf8.decode(response.bodyBytes)))
          .map((u) => User.fromJson(u))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load users');
    }
  }
}
