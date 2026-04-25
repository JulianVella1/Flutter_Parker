import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parker/models/parking_spot.dart';

class ParkingDetailsScreen extends StatelessWidget {
  const ParkingDetailsScreen({
    super.key,
    required this.spot,
    required this.onOpenMaps,
  });

  final ParkingSpot spot;
  final VoidCallback onOpenMaps;

  String get formattedDate {
    final day = spot.parkedAt.day.toString().padLeft(2, '0');
    final month = spot.parkedAt.month.toString().padLeft(2, '0');
    final year = spot.parkedAt.year.toString();
    final hour = spot.parkedAt.hour.toString().padLeft(2, '0');
    final minute = spot.parkedAt.minute.toString().padLeft(2, '0');

    return '$day/$month/$year at $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (spot.imagePath.isNotEmpty)
              Image.file(
                File(spot.imagePath),
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 280,
                color: Colors.grey.shade300,
                child: const Icon(Icons.local_parking, size: 100),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    spot.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text('Parked at: $formattedDate'),
                  const SizedBox(height: 8),
                  Text(
                    'Coordinates: ${spot.latitude.toStringAsFixed(5)}, ${spot.longitude.toStringAsFixed(5)}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    spot.isActive ? 'Status: Active' : 'Status: Ended',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: spot.isActive ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onOpenMaps,
                      icon: const Icon(Icons.map),
                      label: const Text('Open in Google Maps'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
