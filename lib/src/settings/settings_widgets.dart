import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/models/user.dart';

class CurrentUserSettingWidget extends StatelessWidget {
  final AsyncValue<User> userValue;
  final String? userId;
  final Widget title = const Text("User");
  const CurrentUserSettingWidget({
    required this.userValue,
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return ListTile(
        title: title,
        trailing: const Text(
          "NOT CONNECTED",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
      );
    } else {
      return userValue.when<Widget>(
        data: (user) {
          return ListTile(
            title: title,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  userId!,
                  style:
                      const TextStyle(fontFamily: "monospace", fontSize: 10.0),
                ),
              ],
            ),
          );
        },
        error: (err, stack) {
          return ListTile(
            title: title,
            trailing: Text(
              "Error : $err",
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        },
        loading: () {
          return ListTile(
            title: title,
            trailing: Text(
              userId!,
              style: const TextStyle(fontSize: 16.0),
            ),
          );
        },
      );
    }
  }
}

class FavoriteGroupSettingWidget extends StatelessWidget {
  final AsyncValue<Group> groupValue;
  final String? groupId;
  final Widget title = const Text("Favorite Group");
  const FavoriteGroupSettingWidget({
    required this.groupValue,
    required this.groupId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (groupId == null) {
      return ListTile(
        title: title,
        trailing: const Text(
          "NO FAVORITE",
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.red,
          ),
        ),
      );
    } else {
      return groupValue.when<Widget>(
        data: (user) {
          return ListTile(
            title: title,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  groupId!,
                  style:
                      const TextStyle(fontFamily: "monospace", fontSize: 10.0),
                ),
              ],
            ),
          );
        },
        error: (err, stack) {
          return ListTile(
            title: title,
            trailing: Text(
              "Error : $err",
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        },
        loading: () {
          return ListTile(
            title: title,
            trailing: Text(
              groupId!,
              style: const TextStyle(fontSize: 16.0),
            ),
          );
        },
      );
    }
  }
}
