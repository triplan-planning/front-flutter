import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/providers/user_providers.dart';
import 'package:triplan/src/settings/settings_v2.dart';

/// recommended usage : LogoutButton(onSuccess: (ctx) => ctx.goNamed("login"),)
class LogoutButton extends ConsumerWidget {
  const LogoutButton({required this.onSuccess, super.key});
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
