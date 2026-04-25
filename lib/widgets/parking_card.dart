import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parker/models/parking_spot.dart';

class ParkingCard extends StatelessWidget {
  const ParkingCard({
    super.key,
    required this.spot,
    required this.onToggleActive,
    required this.onOpenMaps,
    this.onSelectSpot,
  });

  final ParkingSpot spot;
  final VoidCallback onToggleActive;
  final VoidCallback onOpenMaps;
  final VoidCallback? onSelectSpot;

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
    return InkWell(
      onTap: onSelectSpot,
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: spot.isActive ? Colors.green : Colors.transparent,
            width: spot.isActive ? 2.5 : 0,
          ),
        ),
        elevation: spot.isActive ? 5 : 2,
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            if (spot.imagePath.isNotEmpty)
              Image.file(
                File(spot.imagePath),
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 190,
                color: Colors.grey.shade300,
                child: const Icon(Icons.local_parking, size: 64),
              ),
            Container(
              width: double.infinity,
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              child: Column(
                children: [
                  Text(
                    spot.address,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.schedule, color: Colors.white),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          formattedDate,
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        spot.isActive ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        spot.isActive ? 'Active' : 'Ended',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onOpenMaps,
                      icon: const Icon(Icons.map),
                      label: const Text('Open Maps'),
                    ),
                  ),
                  if (spot.isActive) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onToggleActive,
                        child: const Text('End'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
