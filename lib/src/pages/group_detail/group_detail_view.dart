import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/providers/group_providers.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';
import 'package:triplan/src/widgets/buttons.dart';

/// Displays detailed information about a Group.
class GroupDetailView extends ConsumerStatefulWidget {
  const GroupDetailView(
      {required this.groupId, required this.groupDetailChild, super.key});

  final String groupId;
  final Widget groupDetailChild;

  @override
  _GroupDetailViewState createState() => _GroupDetailViewState();
}

class _GroupDetailViewState extends ConsumerState<GroupDetailView> {
  var tabs = <BottomNavigationBarItemTriplan>[];

  // getter that computes the current index from the current location,
  // using the helper method below
  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  int _locationToTabIndex(String location) {
    final int index = tabs.indexWhere((t) => location.startsWith(t.path));
    log("[NAVBAR] current location : '$location', matching tab : $index");
    // if index not found (-1), return 0
    return index < 0 ? 0 : index;
  }

  // callback used to navigate to the desired tab
  void _onTabButtonTapped(BuildContext context, int tabIndex) {
    if (tabIndex != _currentIndex) {
      // go to the initial location of the selected tab (by index)
      final String path = tabs[tabIndex].path;
      log("[NAVBAR] click on item $tabIndex, navigating to '$path'");
      context.go(path);
    }
  }

  @override
  void initState() {
    tabs = [
      BottomNavigationBarItemTriplan(
        icon: const Icon(Icons.money),
        label: 'Transactions',
        path: '/groups/${widget.groupId}/transactions',
      ),
      BottomNavigationBarItemTriplan(
        icon: const Icon(Icons.balance),
        label: 'Balances',
        path: '/groups/${widget.groupId}/balances',
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<Group> group = ref.watch(singleGroupProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        leading: const PopOrNavigateToNamedLocationButton(
          locationName: "groups_list",
        ),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Hero(
                tag: "group_${widget.groupId}",
                child: const Icon(Icons.flight),
              ),
            ),
            group.toWidgetDataOnly(
              (value) => Text(value.name),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "edit this group",
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          FavoriteGroupButton(groupId: widget.groupId)
        ],
      ),
      body: widget.groupDetailChild,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: tabs,
        onTap: (index) => _onTabButtonTapped(context, index),
        landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
      ),
    );
  }
}

class BottomNavigationBarItemTriplan extends BottomNavigationBarItem {
  const BottomNavigationBarItemTriplan({
    required super.icon,
    required this.path,
    required super.label,
    super.activeIcon,
    super.backgroundColor,
    super.tooltip,
  });

  final String path;
}
