import 'package:geolocator/geolocator.dart';
import 'package:opket/core/services/user_storage.dart';

class AuthService {
  /// Check if location services are enabled
  static Future<bool> isLocationEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<bool> isPhoneShared() async {
    final phone = await UserStorage().getPhone();

    return phone != null;
  }

  static Future<bool> isPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Request permission if needed
  static Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, cannot request again
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Get current position
  static Future<Position?> getCurrentPosition() async {
    if (!await isLocationEnabled()) {
      print("Location services are disabled.");
      return null;
    }

    final hasPermission = await isPermissionGranted();
    if (!hasPermission) {
      print("Location permission denied.");
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
