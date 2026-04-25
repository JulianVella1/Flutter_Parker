import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:parker/data/parking_data.dart';
import 'package:parker/models/parking_spot.dart';
import 'package:parker/screens/history_screen.dart';
import 'package:parker/screens/parkings_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:parker/services/analytics_service.dart';
import 'package:parker/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  List<ParkingSpot> _parkingSpots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParkingSpots();
  }

  Future<void> _loadParkingSpots() async {
    final loadedSpots = await ParkingStorage.loadParkingSpots();

    if (!mounted) {
      return;
    }

    setState(() {
      _parkingSpots = loadedSpots;
      _isLoading = false;
    });
  }

  Future<void> _saveParkingSpots() async {
    await ParkingStorage.saveParkingSpots(_parkingSpots);
  }

  ParkingSpot? get _latestSpot {
    if (_parkingSpots.isEmpty) {
      return null;
    }

    return _parkingSpots.first;
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<Position> _getCurrentLocation() async {
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

  Future<String> _getReadableAddress(double latitude, double longitude) async {
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

  Future<String> _takePhotoAndSave() async {
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

  Future<void> _setParking() async {
    try {
      final imagePath = await _takePhotoAndSave();
      final position = await _getCurrentLocation();
      final address = await _getReadableAddress(
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
        final updatedSpots = _parkingSpots
            .map((spot) => spot.isActive ? spot.copyWith(isActive: false) : spot)
            .toList();

        _parkingSpots = [newSpot, ...updatedSpots];
        _selectedTab = 0;
      });

      await _saveParkingSpots();

      await NotificationService.showParkingSavedNotification();

      await AnalyticsService.logParkingCreated(
        parkingId: newSpot.id,
        address: newSpot.address,
      );

      _showInfoMessage('Parking saved successfully.');
    } catch (error) {
      _showInfoMessage(error.toString());
    }
  }

  Future<void> _endParking(ParkingSpot spot) async {
    final spotIndex = _parkingSpots.indexWhere((item) => item.id == spot.id);

    if (spotIndex == -1) {
      return;
    }

    setState(() {
      _parkingSpots[spotIndex] = _parkingSpots[spotIndex].copyWith(
        isActive: false,
      );
    });

    await _saveParkingSpots();

    await NotificationService.showParkingEndedNotification();

    await AnalyticsService.logParkingEnded(parkingId: spot.id);
    _showInfoMessage('Parking ended.');
  }

  Future<void> _openInGoogleMaps(ParkingSpot spot) async {
    final googleMapsUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${spot.latitude},${spot.longitude}',
    );

    final launched = await launchUrl(
      googleMapsUri,
      mode: LaunchMode.externalApplication,
    );

    if (launched) {
      await AnalyticsService.logMapsOpened(parkingId: spot.id);
    } else if (mounted) {
      _showInfoMessage('Could not open Google Maps.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget screenContent = const Center(child: CircularProgressIndicator());
    String appBarTitle = 'Parker';

    if (!_isLoading) {
      screenContent = switch (_selectedTab) {
        0 => ParkingsScreen(
            latestSpot: _latestSpot,
            onSetParking: _setParking,
            onEndParking: _endParking,
            onOpenMaps: _openInGoogleMaps,
          ),
        1 => HistoryScreen(
            parkingSpots: _parkingSpots,
            onEndParking: _endParking,
            onOpenMaps: _openInGoogleMaps,
          ),
        _ => const Center(child: Text('Unknown tab!')),
      };

      appBarTitle = _selectedTab == 0 ? 'Parker' : 'Parking History';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
      ),
      body: screenContent,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: _selectTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
