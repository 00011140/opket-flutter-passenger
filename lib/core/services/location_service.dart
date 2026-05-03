import 'package:geolocator/geolocator.dart';

class LocationPermissionResult {
  final bool granted;
  final bool asked;

  const LocationPermissionResult({required this.granted, required this.asked});
}

class LocationService {
  /// Check if location services are enabled
  static Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check current permission status
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  static Future<bool> isPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<LocationPermissionResult> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    // If denied, we will ask (system dialog)
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      final granted =
          permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;

      return LocationPermissionResult(granted: granted, asked: true);
    }

    // If deniedForever, can't ask again (no dialog)
    if (permission == LocationPermission.deniedForever) {
      return const LocationPermissionResult(granted: false, asked: false);
    }

    // Otherwise already allowed / restricted-like states (no dialog)
    final granted =
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    return LocationPermissionResult(granted: granted, asked: false);
  }

  /// Get current position
  static Future<Position?> getCurrentPosition() async {
    final hasPermission = await isPermissionGranted();
    if (!hasPermission) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
