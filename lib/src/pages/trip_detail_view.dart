import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:triplan/src/models/spending.dart';
import 'package:triplan/src/models/trip.dart';

/// Displays detailed information about a User.
class TripDetailView extends StatefulWidget {
  const TripDetailView({required this.trip, super.key});

  final Trip trip;
  static const routeName = '/trip';

  @override
  State<TripDetailView> createState() => _TripDetailViewState();
}

class _TripDetailViewState extends State<TripDetailView> {
  late Future<List<Spending>> futureSpendings;

  @override
  void initState() {
    super.initState();
    futureSpendings = fetchSpendingByTripId(widget.trip.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        direction: Axis.vertical,
        children: [
          Text('name: ${widget.trip.name}'),
          Text('id: ${widget.trip.id}'),
          Expanded(
            child: FutureBuilder<List<Spending>>(
              future: futureSpendings,
              builder: ((context, snapshot) {
                var data = snapshot.data;
                if (snapshot.error != null) {
                  return ErrorWidget(snapshot.error!);
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  restorationId: 'TripDetailView',
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final spending = data[index];

                    return ListTile(
                      title: Text('spending: ${spending.title}'),
                      leading: const Icon(Icons.money),
                    );
                  },
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Future<List<Spending>> fetchSpendingByTripId(String tripId) async {
    final response = await http.get(Uri.parse(
        'https://api-go-triplan.up.railway.app/trips/$tripId/spendings'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return List.of(jsonDecode(utf8.decode(response.bodyBytes)))
          .map((u) => Spending.fromJson(u))
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load spendings for trip $tripId');
    }
  }
}
