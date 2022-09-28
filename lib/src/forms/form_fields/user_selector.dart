import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:triplan/src/models/user.dart';

class UserSelector extends StatefulWidget {
  const UserSelector({
    required this.users,
    required this.onChanged,
    this.initialValue,
    super.key,
  });

  final List<User> users;
  final void Function(User?) onChanged;
  final User? initialValue;

  @override
  State<UserSelector> createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue == null) {
      log('[USER SELECTOR] no initial value');
    } else if (!widget.users.contains(widget.initialValue)) {
      log('[USER SELECTOR] invalid initial value ${widget.initialValue!.id}');
    } else {
      log('[USER SELECTOR] initial value : ${widget.initialValue}');
      _selectedUser = widget.initialValue;
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
