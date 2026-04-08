import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/parking_spot.dart';

class ParkingData {
  static const String _storageKey = 'parking_spots';

  static Future<List<ParkingSpot>> loadParkingSpots() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null || savedData.isEmpty) {
      return [];
    }
    final List<dynamic> decodedList = jsonDecode(savedData);
    return decodedList.map((item) => ParkingSpot.fromMap(item)).toList();
  }

  static Future<void> saveParkingSpots(List<ParkingSpot> spots) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = jsonEncode(spots.map((spot) => spot.toMap()).toList());
    await prefs.setString(_storageKey, encodedList);
  }
}
