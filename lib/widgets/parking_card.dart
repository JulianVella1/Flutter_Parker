import 'package:flutter/material.dart';
import 'package:parker/models/parking_spot.dart';

class ParkingCard extends StatelessWidget {
  const ParkingCard({
    super.key,
    required this.spot,
    required this.onToggleActive,
  });

  final ParkingSpot spot;
  final VoidCallback onToggleActive;

  @override
  Widget build(BuildContext context) {
    final isActive = spot.isActive;

    return Card(
      elevation: isActive ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isActive ? Colors.green : Colors.grey.shade300,
          width: isActive ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300,
              ),
              child: const Icon(Icons.image),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    spot.address,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '${spot.latitude.toStringAsFixed(4)}, ${spot.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    spot.parkedAt.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    isActive ? 'ACTIVE' : 'COMPLETED',
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (isActive)
              ElevatedButton(
                onPressed: onToggleActive,
                child: const Text('End'),
              ),
          ],
        ),
      ),
    );
  }
}
