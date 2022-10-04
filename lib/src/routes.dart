import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:triplan/src/forms/create_group_form.dart';
import 'package:triplan/src/forms/create_transaction_form.dart';
import 'package:triplan/src/forms/create_user_form.dart';
import 'package:triplan/src/pages/group_detail_view.dart';
import 'package:triplan/src/pages/homepage.dart';
import 'package:triplan/src/pages/login_view.dart';
import 'package:triplan/src/pages/user_detail_view.dart';
import 'package:triplan/src/settings/settings_controller.dart';
import 'package:triplan/src/settings/settings_view.dart';

RouteMap buildRoutes(
    BuildContext context, SettingsController settingsController) {
  return RouteMap(
    routes: {
      '/': (_) => const MaterialPage(child: HomePage()),
      '/login': (_) => const MaterialPage(child: FakeLoginView()),
      '/settings': ((route) =>
          MaterialPage(child: SettingsView(controller: settingsController))),
      '/users/:id': (info) => MaterialPage(
          child: UserDetailView(userId: info.pathParameters['id']!)),
      '/users/new': (_) => const MaterialPage(child: CreateUserForm()),
      '/groups/-/:groupId/transactions/new': (info) => MaterialPage(
          child:
              CreateTransactionForm(groupId: info.pathParameters['groupId']!)),
      '/groups/:id': (info) => MaterialPage(
          child: GroupDetailView(groupId: info.pathParameters['id']!)),
      '/groups/new': (_) => const MaterialPage(child: CreateGroupForm()),

      // need Tabs on homepage
      //'/users': (_) => MaterialPage(child: UserListView()),
      //'/groups': (_) => MaterialPage(child: GroupListView()),
    },
  );
}
