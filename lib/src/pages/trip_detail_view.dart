import 'package:flutter/material.dart';
import 'package:triplan/src/models/trip.dart';

/// Displays detailed information about a User.
class TripDetailView extends StatelessWidget {
  const TripDetailView({required this.trip, super.key});

  final Trip trip;
  static const routeName = '/trip';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Center(
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.vertical,
          children: [
            Text('name: ${trip.name}'),
            Text('id: ${trip.id}'),
          ],
        ),
      ),
    );
  }
}
