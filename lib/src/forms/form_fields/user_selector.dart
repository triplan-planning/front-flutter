import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/utils/api_tools.dart';

class UserSelector extends StatefulWidget {
  const UserSelector(
      {required this.userIds, required this.onChanged, super.key});

  final List<String> userIds;
  final void Function(User?) onChanged;

  @override
  State<UserSelector> createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  User? _selectedUser;
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    users = fetchMultipleUsers(widget.userIds);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
        future: users,
        builder: ((context, snapshot) {
          var data = snapshot.data;
          if (snapshot.error != null) {
            return ErrorWidget(snapshot.error!);
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (data.isEmpty) {
            return const Center(child: Text("no data"));
          }
          if (_selectedUser == null && data.isNotEmpty) {
            log('[USER SELECTOR] default : ${data[0]}');
            _selectedUser = data[0];
          }
          return DropdownButton<User>(
            value: _selectedUser,
            onChanged: (User? newValue) {
              widget.onChanged(newValue);
              setState(() {
                _selectedUser = newValue;
              });
              log('[USER SELECTOR] selected : $_selectedUser');
            },
            items: data.map((User user) {
              return DropdownMenuItem<User>(
                value: user,
                child: Text(
                  user.name,
                ),
              );
            }).toList(),
          );
        }));
  }

  Future<User> fetchUser(String userId) async {
    Future<User> response =
        fetchAndDecode('/users/$userId', (u) => User.fromJson(u));
    return response;
  }

  Future<List<User>> fetchMultipleUsers(List<String> userIds) async {
    return await Future.wait(userIds.map((id) => fetchUser(id)));
  }
}
