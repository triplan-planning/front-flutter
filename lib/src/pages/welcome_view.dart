import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:triplan/main.dart';
import 'package:triplan/src/models/user.dart';
import 'package:triplan/src/pages/login_view.dart';
import 'package:triplan/src/providers/user_providers.dart';

/// Displays detailed information about a User.
class WelcomeView extends ConsumerWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<User> currentUser = ref.watch(loggedInUserProvider);
    bool loggedIn = null != triplanPreferences!.getString("user_id");

    if (loggedIn) {
      return Center(
        child: currentUser.when(
          data: (user) => Text("Welcome ${user.name}"),
          error: (error, stackTrace) => const Text("something went wrong"),
          loading: () => const CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: ElevatedButton(
            onPressed: () {
              Routemaster.of(context).push(FakeLoginView.routeName);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Log in"),
                Icon(Icons.person),
              ],
            )),
      );
    }
  }
}
