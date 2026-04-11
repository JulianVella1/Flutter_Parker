import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parker/models/parking_spot.dart';
import 'package:parker/screens/parking_details_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.parkingSpots});

  final List<ParkingSpot> parkingSpots;

  String formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year at $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parking History')),
      body: parkingSpots.isEmpty
          ? const Center(
              child: Text(
                'No parking history yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: parkingSpots.length,
              itemBuilder: (context, index) {
                final parking = parkingSpots[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ParkingDetailsScreen(spot: parking),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: parking.imagePath.isNotEmpty
                                ? Image.file(
                                    File(parking.imagePath),
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  parking.address,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${parking.latitude.toStringAsFixed(5)}, '
                                  '${parking.longitude.toStringAsFixed(5)}',
                                ),
                                const SizedBox(height: 6),
                                Text('Time: ${formatDate(parking.parkedAt)}'),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: parking.isActive
                                        ? Colors.green
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    parking.isActive ? 'Active' : 'Ended',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
