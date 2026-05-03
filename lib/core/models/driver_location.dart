import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverLocation {
  final double latitude;
  final double longitude;
  final double? heading;

  const DriverLocation({
    required this.latitude,
    required this.longitude,
    this.heading,
  });

  /// Convert object → Map (JSON / Firebase / Socket)
  Map<String, dynamic> toMap() {
    return {'latitude': latitude, 'longitude': longitude, 'heading': heading};
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  /// Convert Map → object
  factory DriverLocation.fromMap(Map<String, dynamic> map) {
    return DriverLocation(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      heading: map['heading'] != null ? (map['heading'] as num).toDouble() : 0,
    );
  }
}
