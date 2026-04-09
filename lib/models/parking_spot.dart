class ParkingSpot {
  final String id;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime parkedAt;
  final bool isActive;

  ParkingSpot({
    required this.id,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.parkedAt,
    required this.isActive,
  });
}
