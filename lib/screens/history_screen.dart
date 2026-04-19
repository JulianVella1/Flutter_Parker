import 'package:flutter/material.dart';
import 'package:parker/models/parking_spot.dart';
import 'package:parker/screens/parking_details_screen.dart';
import 'package:parker/widgets/parking_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.parkingSpots,
    required this.onEndParking,
    required this.onOpenMaps,
  });

  final List<ParkingSpot> parkingSpots;
  final void Function(ParkingSpot spot) onEndParking;
  final void Function(ParkingSpot spot) onOpenMaps;

  void _selectParking(BuildContext context, ParkingSpot spot) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ParkingDetailsScreen(
          spot: spot,
          onOpenMaps: () {
            onOpenMaps(spot);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (parkingSpots.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Parking History')),
        body: const Center(child: Text('No parking history yet')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Parking History')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: parkingSpots.length,
        itemBuilder: (ctx, index) {
          final spot = parkingSpots[index];

          return ParkingCard(
            spot: spot,
            onToggleActive: () {
              onEndParking(spot);
            },
            onOpenMaps: () {
              onOpenMaps(spot);
            },
            onSelectSpot: () {
              _selectParking(context, spot);
            },
          );
        },
      ),
    );
  }
}
