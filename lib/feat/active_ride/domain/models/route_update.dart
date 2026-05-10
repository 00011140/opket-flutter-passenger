import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteUpdate {
  final String rideId;
  final int distanceMeters;
  final String duration;
  final String polyline;
  final List<LatLngPoint> points;

  RouteUpdate({
    required this.rideId,
    required this.distanceMeters,
    required this.duration,
    required this.polyline,
    required this.points,
  });

  factory RouteUpdate.fromJson(Map<String, dynamic> json) {
    return RouteUpdate(
      rideId: json['rideId'] as String,
      distanceMeters: json['distanceMeters'] != null
          ? json['distanceMeters'] as int
          : 0,
      duration: json['duration'] as String,
      polyline: json['polyline'] as String,
      points: (json['points'] as List<dynamic>)
          .map((e) => LatLngPoint.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'distanceMeters': distanceMeters,
      'duration': duration,
      'polyline': polyline,
      'points': points.map((e) => e.toJson()).toList(),
    };
  }

  static List<LatLng> toLatLngList(List<LatLngPoint> points) {
    return points.map((p) => LatLng(p.lat, p.lng)).toList();
  }
}

class LatLngPoint {
  final double lat;
  final double lng;

  LatLngPoint({required this.lat, required this.lng});

  factory LatLngPoint.fromJson(Map<String, dynamic> json) {
    return LatLngPoint(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}
