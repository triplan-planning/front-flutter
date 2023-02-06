import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:triplan/src/settings/settings_v2.dart';
import 'package:triplan/src/widgets/buttons.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends ConsumerWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(triplanPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const PopOrNavigateToNamedLocationButton(
          locationName: "groups_list",
        ),
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              title: const Text("Theme"),
              trailing: DropdownButton<ThemeMode>(
                // Read the selected themeMode from the controller
                value: controller.themeMode,
                // Call the updateThemeMode method any time the user selects a theme.
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  ref
                      .read(triplanPreferencesProvider.notifier)
                      .setThemeMode(value);
                },
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark Theme'),
                  )
                ],
              ),
            ),
            CheckboxListTile(
              title: const Text("Developer mode"),
              value: controller.devMode,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                ref.read(triplanPreferencesProvider.notifier).setDevMode(value);
              },
            ),
            ListTile(
              title: const Text("User id"),
              trailing: Text(
                controller.userId ?? "NOT CONNECTED",
                style: const TextStyle(fontFamily: "monospace"),
              ),
            ),
            ListTile(
              title: const Text("favorite group"),
              trailing: Text(
                controller.favoriteGroup ?? "NO FAVORITE",
                style: const TextStyle(fontFamily: "monospace"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
