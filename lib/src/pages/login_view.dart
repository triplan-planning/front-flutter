import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/pages/user_list_view.dart';
import 'package:triplan/src/settings/settings_controller.dart';
import 'package:triplan/src/utils/global_providers.dart';

class UserLoginView extends ConsumerStatefulWidget {
  const UserLoginView({super.key});

  static const routeName = '/login';

  @override
  _UserLoginViewState createState() => _UserLoginViewState();
}

class _UserLoginViewState extends ConsumerState<UserLoginView> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    ref.read(currentUserProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login as'),
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(
              onPressed: () async {
                await SettingsController.of(context).updateUserId(null);
                ref.refresh(currentUserProvider);

                if (!mounted) return;
                Navigator.pop(context, true);
              },
              icon: const Icon(
                Icons.logout,
              ))
        ],
      ),
      body: UserListView(
        enableUserCreation: false,
        onPick: (p0) async {
          await SettingsController.of(context).updateUserId(p0.id);
          ref.refresh(currentUserProvider);

          if (!mounted) return;
          Navigator.pop(context, true);
        },
      ),
    );
  }
}
