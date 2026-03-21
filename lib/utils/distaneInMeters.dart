import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

double distanceInMeters(LatLng a, LatLng b) {
  const earthRadius = 6371000;
  final dLat = _degToRad(b.latitude - a.latitude);
  final dLng = _degToRad(b.longitude - a.longitude);

  final lat1 = _degToRad(a.latitude);
  final lat2 = _degToRad(b.latitude);

  final h =
      sin(dLat / 2) * sin(dLat / 2) +
      sin(dLng / 2) * sin(dLng / 2) * cos(lat1) * cos(lat2);

  return 2 * earthRadius * asin(sqrt(h));
}

double _degToRad(double deg) => deg * pi / 180;
