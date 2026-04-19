import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parker/data/parking_data.dart';
import 'package:parker/models/parking_spot.dart';
import 'package:parker/screens/history_screen.dart';
import 'package:parker/widgets/parking_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ParkingSpot> parkingSpots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadParkingSpots();
  }

  Future<void> loadParkingSpots() async {
    final loadedSpots = await ParkingStorage.loadParkingSpots();

    if (!mounted) {
      return;
    }

    setState(() {
      parkingSpots = loadedSpots;
      isLoading = false;
    });
  }

  Future<void> saveParkingSpots() async {
    await ParkingStorage.saveParkingSpots(parkingSpots);
  }

  ParkingSpot? get latestSpot {
    if (parkingSpots.isEmpty) {
      return null;
    }

    return parkingSpots.first;
  }

  void showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<Position> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    return Geolocator.getCurrentPosition();
  }

  Future<String> getReadableAddress(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return 'Unknown road';
      }

      final place = placemarks.first;
      final parts = [place.street, place.subLocality, place.locality];

      final cleanedParts = parts
          .where((part) => part != null && part.trim().isNotEmpty)
          .cast<String>()
          .toList();

      if (cleanedParts.isEmpty) {
        return 'Unknown road';
      }

      return cleanedParts.join(', ');
    } catch (_) {
      return 'Unknown road';
    }
  }

  Future<String> takePhotoAndSave() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (pickedImage == null) {
      throw Exception('No image was taken.');
    }

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final savedImage = await File(
      pickedImage.path,
    ).copy('${appDir.path}/$fileName.jpg');

    return savedImage.path;
  }

  Future<void> openInGoogleMaps(ParkingSpot spot) async {
    final googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${spot.latitude},${spot.longitude}',
    );

    final launched = await launchUrl(
      googleMapsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      showInfoMessage('Could not open Google Maps.');
    }
  }

  Future<void> setParking() async {
    try {
      final imagePath = await takePhotoAndSave();
      final position = await getCurrentLocation();
      final address = await getReadableAddress(
        position.latitude,
        position.longitude,
      );

      final newSpot = ParkingSpot(
        id: DateTime.now().toIso8601String(),
        imagePath: imagePath,
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        parkedAt: DateTime.now(),
        isActive: true,
      );

      setState(() {
        parkingSpots = [newSpot, ...parkingSpots];
      });

      await saveParkingSpots();
      showInfoMessage('Parking saved successfully.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      showInfoMessage(error.toString());
    }
  }

  Future<void> endParking(ParkingSpot spot) async {
    final spotIndex = parkingSpots.indexWhere((item) => item.id == spot.id);

    if (spotIndex == -1) {
      return;
    }

    setState(() {
      parkingSpots[spotIndex] = parkingSpots[spotIndex].copyWith(
        isActive: false,
      );
    });

    await saveParkingSpots();
    showInfoMessage('Parking ended.');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parker'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HistoryScreen(
                    parkingSpots: parkingSpots,
                    onEndParking: endParking,
                    onOpenMaps: openInGoogleMaps,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            GestureDetector(
              onTap: setParking,
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.primaryContainer],
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
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
            if (isLoading)
              const CircularProgressIndicator()
            else if (latestSpot == null)
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
                onToggleActive: () => endParking(latestSpot!),
                onOpenMaps: () => openInGoogleMaps(latestSpot!),
              ),
          ],
        ),
      ),
    );
  }
}
