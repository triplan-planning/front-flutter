import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/models/user.dart';

class UserListItem extends ConsumerWidget {
  const UserListItem({required this.user, this.onTap, super.key});

  final User user;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(
        'user: ${user.name}',
      ),
      leading: Hero(
        tag: "user_${user.id}",
        child: const Icon(Icons.person),
      ),
      onTap: onTap,
    );
  }
}
