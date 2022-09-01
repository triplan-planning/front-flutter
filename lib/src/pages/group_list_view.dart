import 'package:flutter/material.dart';
import 'package:triplan/src/forms/create_group_form.dart';
import 'package:triplan/src/models/group.dart';
import 'package:triplan/src/pages/group_detail_view.dart';
import 'package:triplan/src/utils/api_tools.dart';

class GroupListView extends StatefulWidget {
  const GroupListView({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupListView> createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView> {
  late Future<List<Group>> futureGroups;

  @override
  void initState() {
    super.initState();
    futureGroups = fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateGroupForm.routeName)
              .then((_) => setState(() {
                    futureGroups = fetchGroups();
                  }));
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Group>>(
          future: futureGroups,
          builder: (context, snapshot) {
            var data = snapshot.data;
            if (snapshot.error != null) {
              return ErrorWidget(snapshot.error!);
            }
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              restorationId: 'GroupListView',
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final group = data[index];

                return ListTile(
                    title: Text('group: ${group.name}'),
                    leading: const Icon(Icons.flight),
                    onTap: () {
                      Navigator.pushNamed(context, GroupDetailView.routeName,
                              arguments: group)
                          .then((value) => setState(() {
                                futureGroups = fetchGroups();
                              }));
                    });
              },
            );
          }),
    );
  }

  Future<List<Group>> fetchGroups() async {
    Future<List<Group>> response = fetchAndDecodeList(
        '/groups', (l) => l.map((e) => Group.fromJson(e)).toList());
    return response;
  }
}
