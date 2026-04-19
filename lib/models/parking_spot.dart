class ParkingSpot {
  const ParkingSpot({
    required this.id,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.parkedAt,
    required this.isActive,
  });

  final String id;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime parkedAt;
  final bool isActive;

  ParkingSpot copyWith({
    String? id,
    String? imagePath,
    double? latitude,
    double? longitude,
    String? address,
    DateTime? parkedAt,
    bool? isActive,
  }) {
    return ParkingSpot(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      parkedAt: parkedAt ?? this.parkedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
