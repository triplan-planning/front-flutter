import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/pages/user_detail_view.dart';

import '../settings/settings_view.dart';

import 'package:http/http.dart' as http;

class UserListView extends StatefulWidget {
  const UserListView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

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
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: FutureBuilder<List<User>>(
          future: futureUsers,
          builder: (context, snapshot) {
            var data = snapshot.data;
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'sampleItemListView',
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final user = data[index];

                return ListTile(
                    title: Text('user: ${user.name}'),
                    leading: const CircleAvatar(
                      // Display the Flutter Logo image asset.
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                    onTap: () {
                      // Navigate to the details page. If the user leaves and returns to
                      // the app after it has been killed while running in the
                      // background, the navigation stack is restored.
                      Navigator.pushNamed(context, UserDetailView.routeName,
                          arguments: user);
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
      throw Exception('Failed to load User');
    }
  }
}
