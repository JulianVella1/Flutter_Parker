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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (spot.imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(spot.imagePath),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.local_parking, size: 80),
              ),
            const SizedBox(height: 20),
            Text(spot.address, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              'Latitude: ${spot.latitude.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Longitude: ${spot.longitude.toStringAsFixed(5)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Parked at: $formattedDate',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${spot.isActive ? 'Active' : 'Ended'}',
              style: TextStyle(
                fontSize: 16,
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
    );
  }
}
