import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/providers/user_providers.dart';
import 'package:triplan/src/settings/settings_v2.dart';

void redirectToLogin(BuildContext ctx) {
  GoRouter.of(ctx).pushNamed("login");
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({this.onSuccess = redirectToLogin, super.key});
  final Function(BuildContext) onSuccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () async {
          ref.read(triplanPreferencesProvider.notifier).setUserId(null);
          ref.refresh(loggedInUserProvider);

          onSuccess(context);
        },
        icon: const Icon(
          Icons.logout,
        ));
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () {
        GoRouter.of(context).pushNamed("settings");
      },
    );
  }
}
