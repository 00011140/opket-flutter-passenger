import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverLocation {
  final double lat;
  final double lon;
  final double? bearing;

  const DriverLocation({required this.lat, required this.lon, this.bearing});

  /// Convert object → Map (JSON / Firebase / Socket)
  Map<String, dynamic> toMap() {
    return {'lat': lat, 'lon': lon, 'bearing': bearing};
  }

  LatLng toLatLng() {
    return LatLng(lat, lon);
  }

  /// Convert Map → object
  factory DriverLocation.fromMap(Map<String, dynamic> map) {
    return DriverLocation(
      lat: (map['lat'] as num).toDouble(),
      lon: (map['lon'] as num).toDouble(),
      bearing: map['bearing'] != null ? (map['bearing'] as num).toDouble() : 0,
    );
  }
}
