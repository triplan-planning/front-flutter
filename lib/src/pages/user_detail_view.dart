import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:triplan/src/models/user.dart';
import 'package:http/http.dart' as http;

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
              icon: Icon(
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
    final response = await http.delete(
        Uri.parse('https://api-go-triplan.up.railway.app/users/${user.id}'));

    if (response.statusCode != 204) {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete user users');
    }
    Navigator.of(context).pop();
  }
}
