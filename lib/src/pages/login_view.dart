import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/pages/user_list_view.dart';
import 'package:triplan/src/providers/user_providers.dart';
import 'package:triplan/src/settings/settings_v2.dart';

class FakeLoginView extends ConsumerStatefulWidget {
  const FakeLoginView({super.key});

  @override
  _UserLoginViewState createState() => _UserLoginViewState();
}

class _UserLoginViewState extends ConsumerState<FakeLoginView> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    ref.read(loggedInUserProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Login as'),
        backgroundColor: Colors.cyan,
      ),
      body: UserListView(
        enableUserCreation: false,
        onPick: (p0) async {
          ref.read(triplanPreferencesProvider.notifier).setUserId(p0.id);
          ref.refresh(loggedInUserProvider);

          if (!mounted) return;
          context.goNamed("homepage");
        },
      ),
    );
  }
}
