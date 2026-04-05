
class Location {
  Location({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  Location copyWith({
    double? latitude,
    double? longitude,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

