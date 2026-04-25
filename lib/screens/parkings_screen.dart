import 'package:flutter/material.dart';
import 'package:parker/models/parking_spot.dart';
import 'package:parker/widgets/parking_card.dart';

class ParkingsScreen extends StatelessWidget {
  const ParkingsScreen({
    super.key,
    required this.latestSpot,
    required this.onSetParking,
    required this.onEndParking,
    required this.onOpenMaps,
  });

  final ParkingSpot? latestSpot;
  final VoidCallback onSetParking;
  final void Function(ParkingSpot spot) onEndParking;
  final void Function(ParkingSpot spot) onOpenMaps;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          InkWell(
            onTap: onSetParking,
            borderRadius: BorderRadius.circular(28),
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.20),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Image.asset(
                        'assets/icons/logo_main.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: Text(
                      'Set Parking',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (latestSpot == null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.local_parking_outlined,
                      size: 42,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No parking saved yet.',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ParkingCard(
              spot: latestSpot!,
              onToggleActive: () {
                onEndParking(latestSpot!);
              },
              onOpenMaps: () {
                onOpenMaps(latestSpot!);
              },
            ),
        ],
      ),
    );
  }
}
