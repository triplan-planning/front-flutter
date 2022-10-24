import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/forms/create_group_form.dart';
import 'package:triplan/src/forms/create_transaction_form.dart';
import 'package:triplan/src/pages/group_detail_view.dart';
import 'package:triplan/src/pages/group_list_view.dart';
import 'package:triplan/src/pages/login_view.dart';
import 'package:triplan/src/pages/user_detail_view.dart';
import 'package:triplan/src/settings/settings_v2.dart';
import 'package:triplan/src/settings/settings_view.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: 'homepage',
        redirect: (context, state) => state.namedLocation("groups_list"),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: FakeLoginView());
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: SettingsView());
        },
      ),
      GoRoute(
        path: '/users/user_id',
        name: 'users_detail',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return MaterialPage(
              child: UserDetailView(userId: state.params["user_id"]!));
        },
      ),
      GoRoute(
        path: '/users/new',
        name: 'users_new',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: CreateGroupForm());
        },
      ),
      GoRoute(
        path: '/groups',
        name: 'groups_list',
        builder: (BuildContext context, GoRouterState state) {
          return const GroupListView();
        },
      ),
      GoRoute(
        path: '/groups/favorite',
        name: 'groups_favorite',
        redirect: (context, state) {
          return "/groups";
        },
      ),
      GoRoute(
        path: '/groups/new',
        name: 'groups_new',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: CreateGroupForm());
        },
      ),
      GoRoute(
        path: '/groups/:group_id',
        name: 'groups_detail',
        builder: (BuildContext context, GoRouterState state) {
          return GroupDetailView(groupId: state.params["group_id"]!);
        },
      ),
      GoRoute(
        path: '/groups/:group_id/transactions/new',
        name: 'new_transaction',
        pageBuilder: (context, state) => MaterialPage(
            child: CreateTransactionForm(groupId: state.params['group_id']!)),
      ),
    ],
    initialLocation: "/groups",
    errorBuilder: (context, state) => ErrorWidget(state.error!),
    redirect: (context, state) {
      final loginLoc = state.namedLocation("login");
      final bool loggedIn = null != ref.read(triplanPreferencesProvider).userId;
      final bool accessingLoginPage = state.location == loginLoc;

      if (!accessingLoginPage && !loggedIn) {
        log("[REDIRECT] redirected to login page (instead of ${state.location})");
        return loginLoc;
      } else {
        log("[REDIRECT] allowed to access ${state.location}");
        return null;
      }
    },
  );
});
