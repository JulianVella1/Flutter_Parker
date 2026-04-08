class ParkingSpot {
  final String id;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String address;
  final String parkedAt;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'parkedAt': parkedAt,
      'isActive': isActive,
    };
  }

  static ParkingSpot fromMap(Map<String, dynamic> map) {
    return ParkingSpot(
      id: map['id'],
      imagePath: map['imagePath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      parkedAt: map['parkedAt'],
      isActive: map['isActive'],
    );
  }
}
