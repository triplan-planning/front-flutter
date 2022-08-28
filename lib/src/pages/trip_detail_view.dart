import 'package:flutter/material.dart';
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
            Text('name: ${widget.trip.name}'),
            Text('id: ${widget.trip.id}'),
          ],
        ),
      ),
    );
  }
}
