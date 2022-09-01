import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  late Future<List<Group>> futureTrips;

  @override
  void initState() {
    super.initState();
    futureTrips = fetchTrips();
  }

  @override
  Widget build(BuildContext context) {
    // To work with lists that may contain a large number of items, it’s best
    // to use the ListView.builder constructor.
    //
    // In contrast to the default ListView constructor, which requires
    // building all Widgets up front, the ListView.builder constructor lazily
    // builds Widgets as they’re scrolled into view.
    return FutureBuilder<List<Group>>(
        future: futureTrips,
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (snapshot.error != null) {
            return ErrorWidget(snapshot.error!);
          }
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            restorationId: 'TripListView',
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final group = data[index];

              return ListTile(
                  title: Text('group: ${group.name}'),
                  leading: const Icon(Icons.flight),
                  onTap: () {
                    // Navigate to the details page. If the user leaves and returns to
                    // the app after it has been killed while running in the
                    // background, the navigation stack is restored.
                    Navigator.pushNamed(context, GroupDetailView.routeName,
                        arguments: group);
                  });
            },
          );
        });
  }

  Future<List<Group>> fetchTrips() async {
    Future<List<Group>> response = fetchAndDecodeList(
        '/groups', (l) => l.map((e) => Group.fromJson(e)).toList());
    return response;
  }
}
