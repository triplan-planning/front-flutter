import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:triplan/src/models/user.dart';

class UserSelector extends StatefulWidget {
  const UserSelector({required this.users, required this.onChanged, super.key});

  final List<User> users;
  final void Function(User?) onChanged;

  @override
  State<UserSelector> createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    if (_selectedUser == null && widget.users.isNotEmpty) {
      log('[USER SELECTOR] default : ${widget.users[0]}');
      _selectedUser = widget.users[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<User>(
      value: _selectedUser,
      onChanged: (User? newValue) {
        widget.onChanged(newValue);
        setState(() {
          _selectedUser = newValue;
        });
        log('[USER SELECTOR] selected : $_selectedUser');
      },
      items: widget.users.map((User user) {
        return DropdownMenuItem<User>(
          value: user,
          child: Text(
            user.name,
          ),
        );
      }).toList(),
    ); //here
  }
}
