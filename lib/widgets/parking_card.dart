import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parker/models/parking_spot.dart';

class ParkingCard extends StatelessWidget {
  const ParkingCard({
    super.key,
    required this.spot,
    required this.onToggleActive,
    required this.onOpenMaps,
  });

  final ParkingSpot spot;
  final VoidCallback onToggleActive;
  final VoidCallback onOpenMaps;

  String getFormattedDate() {
    final day = spot.parkedAt.day.toString().padLeft(2, '0');
    final month = spot.parkedAt.month.toString().padLeft(2, '0');
    final year = spot.parkedAt.year.toString();
    final hour = spot.parkedAt.hour.toString().padLeft(2, '0');
    final minute = spot.parkedAt.minute.toString().padLeft(2, '0');

    return '$day/$month/$year at $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = spot.isActive;

    return Card(
      elevation: isActive ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isActive ? Colors.green : Colors.grey.shade300,
          width: isActive ? 2.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: spot.imagePath.isNotEmpty
                      ? Image.file(
                          File(spot.imagePath),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 90,
                          height: 90,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.local_parking, size: 36),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spot.address,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        getFormattedDate(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isActive ? 'ACTIVE' : 'ENDED',
                        style: TextStyle(
                          color: isActive ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onOpenMaps,
                    icon: const Icon(Icons.map),
                    label: const Text('Open Maps'),
                  ),
                ),
                if (isActive) ...[
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
          ],
        ),
      ),
    );
  }
}
