import 'package:flutter/material.dart';
import 'package:parker/data/parking_data.dart';
import 'package:parker/models/parking_spot.dart';
import 'package:parker/widgets/parking_card.dart';

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

  Future<void> setParking() async {
    final newSpot = ParkingSpot(
      id: DateTime.now().toString(),
      imagePath: '',
      latitude: 0,
      longitude: 0,
      address: 'Parking spot',
      parkedAt: DateTime.now(),
      isActive: true,
    );

    setState(() {
      parkingSpots.insert(0, newSpot);
    });

    await saveParkingSpots();
  }

  Future<void> endParking() async {
    if (latestSpot == null) {
      return;
    }

    final updatedSpot = ParkingSpot(
      id: latestSpot!.id,
      imagePath: latestSpot!.imagePath,
      latitude: latestSpot!.latitude,
      longitude: latestSpot!.longitude,
      address: latestSpot!.address,
      parkedAt: latestSpot!.parkedAt,
      isActive: false,
    );

    setState(() {
      parkingSpots[0] = updatedSpot;
    });

    await saveParkingSpots();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Parker'), centerTitle: true),
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
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Set Parking!',
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
            const SizedBox(height: 32),
            if (isLoading)
              const CircularProgressIndicator()
            else if (latestSpot == null)
              const Text('No parking yet')
            else
              ParkingCard(spot: latestSpot!, onToggleActive: endParking),
          ],
        ),
      ),
    );
  }
}
