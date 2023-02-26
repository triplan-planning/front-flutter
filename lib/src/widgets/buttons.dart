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

class FavoriteGroupButton extends ConsumerWidget {
  const FavoriteGroupButton({required this.groupId, super.key});
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.read(triplanPreferencesProvider.notifier);
    String? favoriteGroupId = prefs.favoriteGroup;

    bool isFavorite = favoriteGroupId != null && groupId == favoriteGroupId;
    if (isFavorite) {
      return IconButton(
        onPressed: () async {
          prefs.setFavoriteGroup(null);
        },
        icon: const Icon(Icons.favorite),
        tooltip: "mark this group as favorite",
      );
    } else {
      return IconButton(
        onPressed: () async {
          prefs.setFavoriteGroup(groupId);
        },
        icon: const Icon(Icons.favorite_border),
        tooltip: "mark this group as not favorite",
      );
    }
  }
}

class PopOrNavigateToNamedLocationButton extends StatelessWidget {
  const PopOrNavigateToNamedLocationButton({
    required this.locationName,
    this.params,
    this.onButtonPressed,
    super.key,
  });
  final String locationName;
  final Map<String, String>? params;
  final Function()? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        if (null != onButtonPressed) {
          onButtonPressed!();
        }

        var nav = Navigator.of(context);
        if (nav.canPop()) {
          nav.pop();
        } else {
          context.goNamed(locationName, params: params ?? {});
        }
      },
    );
  }
}
