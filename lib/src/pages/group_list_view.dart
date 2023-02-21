import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/providers/group_providers.dart';
import 'package:triplan/src/utils/api_tools.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';
import 'package:triplan/src/widgets/buttons.dart';

class GroupListView extends ConsumerStatefulWidget {
  const GroupListView({Key? key}) : super(key: key);

  @override
  _GroupListViewState createState() => _GroupListViewState();
}

class _GroupListViewState extends ConsumerState<GroupListView> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Group>> groups = ref.watch(allGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
        actions: const [
          SettingsButton(),
          LogoutButton(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GoRouter.of(context).pushNamed("groups_new");
          ref.refresh(allGroupsProvider);
        },
        child: const Icon(Icons.add),
      ),
      body: groups.toWidget(
        (value) => ListView.builder(
          restorationId: 'GroupListView',
          itemCount: value.length,
          itemBuilder: (BuildContext context, int index) {
            final group = value[index];

            return ListTile(
                title: Text(group.name),
                leading: Hero(
                  tag: "group_${group.id}",
                  child: const Icon(Icons.group),
                ),
                trailing: Text('(${group.userIds.length})'),
                onTap: () {
                  // TODO : use push instead of go
                  // opened issue : https://github.com/flutter/flutter/issues/111842
                  context.goNamed(
                    "groups_detail_balances",
                    params: {"group_id": group.id},
                  );
                  ref.refresh(allGroupsProvider);
                });
          },
        ),
      ),
    );
  }

  Future<List<Group>> fetchGroups() async {
    Future<List<Group>> response = fetchAndDecodeList(
        '/groups', (l) => l.map((e) => Group.fromJson(e)).toList());
    return response;
  }
}
