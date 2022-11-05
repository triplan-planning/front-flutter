import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/forms/create_group_form.dart';
import 'package:triplan/src/forms/create_transaction_form.dart';
import 'package:triplan/src/pages/group_detail/group_detail_view.dart';
import 'package:triplan/src/pages/group_detail/transactions_screen.dart';
import 'package:triplan/src/pages/group_detail/users_screen.dart';
import 'package:triplan/src/pages/group_list_view.dart';
import 'package:triplan/src/pages/login_view.dart';
import 'package:triplan/src/pages/user_detail_view.dart';
import 'package:triplan/src/settings/settings_v2.dart';
import 'package:triplan/src/settings/settings_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _groupDetailShellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
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
        name: 'favorite',
        redirect: (context, state) {
          String? favGroupId =
              ref.read(triplanPreferencesProvider).favoriteGroup;
          if (null == favGroupId) {
            return state.namedLocation("groups_list");
          } else {
            return state.namedLocation("groups_detail",
                params: {"group_id": favGroupId});
          }
        },
      ),
      GoRoute(
        path: '/groups/new',
        name: 'groups_new',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return const MaterialPage(child: CreateGroupForm());
        },
      ),
      ShellRoute(
        navigatorKey: _groupDetailShellNavigatorKey,
        builder: (context, state, child) {
          // TODO : find a better way to access the group id
          // state params empty here :(
          String groupId = state.location.split("/")[2];
          return GroupDetailView(
            groupDetailChild: child,
            groupId: groupId,
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/groups/:group_id',
            name: 'groups_detail',
            redirect: (context, state) {
              log("[REDIRECT] redirect to default group detail tab");
              return state.namedLocation(
                "groups_detail_transactions",
                params: {
                  "group_id": state.params["group_id"]!,
                },
              );
            },
          ),
          GoRoute(
            path: '/groups/:group_id/transactions',
            name: 'groups_detail_transactions',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: GroupDetailTransactionList(
                  groupId: state.params["group_id"]!,
                ),
              );
            },
          ),
          GoRoute(
            path: '/groups/:group_id/balances',
            name: 'groups_detail_balances',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: GroupDetailBalanceList(
                  groupId: state.params["group_id"]!,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/groups/:group_id/transactions/new',
        name: 'new_transaction',
        pageBuilder: (context, state) => MaterialPage(
            child: CreateTransactionForm(groupId: state.params['group_id']!)),
      ),
    ],
    initialLocation: "/groups/favorite",
    errorBuilder: (context, state) => ErrorWidget(state.error!),
    navigatorKey: _rootNavigatorKey,
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
