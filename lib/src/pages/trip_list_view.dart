import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triplan/src/models/trip.dart';
import 'package:triplan/src/pages/trip_detail_view.dart';

class TripListView extends StatefulWidget {
  const TripListView({
    Key? key,
  }) : super(key: key);

  @override
  State<TripListView> createState() => _TripListViewState();
}

class _TripListViewState extends State<TripListView> {
  late Future<List<Trip>> futureTrips;

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
    return FutureBuilder<List<Trip>>(
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
            // Providing a restorationId allows the ListView to restore the
            // scroll position when a user leaves and returns to the app after it
            // has been killed while running in the background.
            restorationId: 'sampleItemListView',
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final trip = data[index];

              return ListTile(
                  title: Text('trip: ${trip.name}'),
                  leading: const CircleAvatar(
                    // Display the Flutter Logo image asset.
                    foregroundImage:
                        AssetImage('assets/images/flutter_logo.png'),
                  ),
                  onTap: () {
                    // Navigate to the details page. If the user leaves and returns to
                    // the app after it has been killed while running in the
                    // background, the navigation stack is restored.
                    Navigator.pushNamed(context, TripDetailView.routeName,
                        arguments: trip);
                  });
            },
          );
        });
  }

  Future<List<Trip>> fetchTrips() async {
    final response = await http
        .get(Uri.parse('https://api-go-triplan.up.railway.app/trips'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return List.of(jsonDecode(utf8.decode(response.bodyBytes)))
          .map((u) => Trip.fromJson(u))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load trips');
    }
  }
}
