import 'package:parker/models/parking_spot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkingStorage {
  static const String parkingSpotsKey = 'parking_spots';
  static const String separator = '~@~';

  static Future<void> saveParkingSpots(List<ParkingSpot> spots) async {
    final prefs = await SharedPreferences.getInstance();

    final savedList = spots.map((spot) {
      return [
        spot.id,
        spot.imagePath,
        spot.latitude.toString(),
        spot.longitude.toString(),
        spot.address,
        spot.parkedAt.toIso8601String(),
        spot.isActive.toString(),
      ].join(separator);
    }).toList();

    await prefs.setStringList(parkingSpotsKey, savedList);
  }

  static Future<List<ParkingSpot>> loadParkingSpots() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(parkingSpotsKey) ?? [];

    return savedList.map((item) {
      final parts = item.split(separator);

      return ParkingSpot(
        id: parts[0],
        imagePath: parts[1],
        latitude: double.parse(parts[2]),
        longitude: double.parse(parts[3]),
        address: parts[4],
        parkedAt: DateTime.parse(parts[5]),
        isActive: parts[6] == 'true',
      );
    }).toList();
  }
}
