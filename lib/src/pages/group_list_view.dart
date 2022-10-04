import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:triplan/src/forms/create_group_form.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/pages/group_detail_view.dart';
import 'package:triplan/src/providers/group_providers.dart';
import 'package:triplan/src/utils/api_tools.dart';
import 'package:triplan/src/utils/provider_wrappers.dart';

class GroupListView extends ConsumerStatefulWidget {
  const GroupListView({
    Key? key,
  }) : super(key: key);

  @override
  _GroupListViewState createState() => _GroupListViewState();
}

class _GroupListViewState extends ConsumerState<GroupListView> {
  @override
  Widget build(BuildContext context) {
    AsyncValue<List<Group>> groups = ref.watch(allGroupsProvider);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Routemaster.of(context)
              .push(CreateGroupForm.routeName)
              .result
              .whenComplete(() => ref.refresh(allGroupsProvider));
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
                title: Text('group: ${group.name}'),
                leading: Hero(
                  tag: "group_${group.id}",
                  child: const Icon(Icons.flight),
                ),
                onTap: () {
                  Routemaster.of(context)
                      .push("groups/${group.id}")
                      .result
                      .whenComplete(() => ref.refresh(allGroupsProvider));
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
