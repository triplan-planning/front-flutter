import 'package:flutter/material.dart';
import 'package:triplan/src/settings/settings_controller.dart';

/// Displays detailed information about a User.
class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child:
            Text("Welcome ${SettingsController.of(context).userId ?? "???"}"));
  }
}
