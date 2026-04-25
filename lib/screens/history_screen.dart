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
    Widget content = ListView.builder(
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
    );

    if (parkingSpots.isEmpty) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Uh oh... nothing here!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Start by saving your first parking spot.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return content;
  }
}
