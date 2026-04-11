import 'dart:io';

import 'package:flutter/material.dart';
import 'package:parker/models/parking_spot.dart';
import 'package:parker/screens/parking_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.parkingSpots});

  final List<ParkingSpot> parkingSpots;

  Future<void> openInGoogleMaps(double lat, double lng) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

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
      appBar: AppBar(
        title: const Text('Parking History'),
      ),
      body: parkingSpots.isEmpty
          ? const Center(
              child: Text('No parking history yet'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: parkingSpots.length,
              itemBuilder: (context, index) {
                final parking = parkingSpots[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: parking.imagePath.isNotEmpty
                          ? Image.file(
                              File(parking.imagePath),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.local_parking),
                            ),
                    ),
                    title: Text(
                      parking.address,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(formatDate(parking.parkedAt)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: parking.isActive
                                ? Colors.green.shade100
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            parking.isActive ? 'Active' : 'Ended',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: parking.isActive
                                  ? Colors.green.shade800
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.map),
                      onPressed: () => openInGoogleMaps(
                        parking.latitude,
                        parking.longitude,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              ParkingDetailsScreen(spot: parking),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}