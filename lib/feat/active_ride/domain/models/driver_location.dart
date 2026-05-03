class DriverLocation {
  final double latitude;
  final double longitude;
  final double? heading;
  final double? speed;
  final DateTime? timestamp;

  const DriverLocation({
    required this.latitude,
    required this.longitude,
    this.heading,
    this.speed,
    this.timestamp,
  });

  DriverLocation copyWith({
    double? latitude,
    double? longitude,
    double? heading,
    double? speed,
    DateTime? timestamp,
  }) {
    return DriverLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      if (heading != null) "heading": heading,
      if (speed != null) "speed": speed,
      if (timestamp != null) "ts": timestamp?.millisecondsSinceEpoch,
    };
  }
}
