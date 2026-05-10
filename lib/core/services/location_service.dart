import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';

class LocationPermissionResult {
  final bool granted;
  final bool asked;

  const LocationPermissionResult({required this.granted, required this.asked});
}

class LocationService {
  // Positions worse than this accuracy are treated as unreliable.
  // 50m covers most real-world warm-GPS scenarios; cold start may take longer.
  static const double accuracyThresholdMeters = 50.0;

  // Maximum wait for a stable fix. After this we fall back to best seen so far.
  // 15s is enough for a cold GPS fix indoors on most modern devices.
  static const Duration _stableFixTimeout = Duration(seconds: 15);

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

  /// Single-shot position fetch. May return a coarse fix on cold GPS start.
  /// Prefer [getStablePosition] for initial map centering.
  /// Use this for recenter button where responsiveness > accuracy (GPS already warm).
  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await isPermissionGranted();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: _buildLocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 0,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Waits for a GPS fix with accuracy ≤ [accuracyThreshold] meters before
  /// resolving. Falls back to the best position seen after [timeout] elapses.
  ///
  /// Use this instead of [getCurrentPosition] for initial map centering.
  /// On cold start, the first OS fix can be 100–500 m off (cell tower /
  /// cached network location). Streaming and filtering by accuracy prevents
  /// the camera from snapping to a wrong spot and then correcting itself.
  static Future<Position?> getStablePosition({
    double accuracyThreshold = accuracyThresholdMeters,
    Duration timeout = _stableFixTimeout,
  }) async {
    try {
      final hasPermission = await isPermissionGranted();
      if (!hasPermission) return null;

      Position? bestSoFar;
      final completer = Completer<Position?>();
      StreamSubscription<Position>? sub;
      Timer? timeoutTimer;

      // Timeout fallback: if GPS never converges within the window, use the
      // best fix we collected so far rather than blocking indefinitely.
      timeoutTimer = Timer(timeout, () {
        sub?.cancel();
        if (!completer.isCompleted) completer.complete(bestSoFar);
      });

      sub = Geolocator.getPositionStream(
        locationSettings: _buildLocationSettings(
          accuracy: LocationAccuracy.best,
          // distanceFilter: 0 so every update is received, even tiny GPS jumps,
          // allowing us to detect accuracy improvement as quickly as possible.
          distanceFilter: 0,
        ),
      ).listen(
        (position) {
          // Always track the most accurate fix seen so we have a fallback
          if (bestSoFar == null || position.accuracy < bestSoFar!.accuracy) {
            bestSoFar = position;
          }

          // Resolve as soon as we have a fix good enough to center the map
          if (position.accuracy <= accuracyThreshold) {
            sub?.cancel();
            timeoutTimer?.cancel();
            if (!completer.isCompleted) completer.complete(position);
          }
        },
        onError: (_) {
          sub?.cancel();
          timeoutTimer?.cancel();
          if (!completer.isCompleted) completer.complete(bestSoFar);
        },
        cancelOnError: false,
      );

      return completer.future;
    } catch (e) {
      return null;
    }
  }

  /// Ongoing filtered position stream for real-time location tracking.
  ///
  /// Only emits positions with accuracy ≤ [accuracyThreshold] and when the
  /// device has moved at least [distanceFilter] meters. The distance filter
  /// suppresses redundant updates, conserving battery while the user is idle.
  static Stream<Position> getAccuratePositionStream({
    double accuracyThreshold = accuracyThresholdMeters,
    int distanceFilter = 5,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: _buildLocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilter,
      ),
    ).where((pos) => pos.accuracy <= accuracyThreshold);
  }

  /// Builds platform-aware location settings.
  ///
  /// Android: uses Fused Location Provider (battery-efficient, high accuracy).
  /// iOS: uses CoreLocation via AppleSettings.
  static LocationSettings _buildLocationSettings({
    required LocationAccuracy accuracy,
    required int distanceFilter,
  }) {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        // false = use Google Play Services Fused Provider (recommended).
        // true would fall back to legacy LocationManager (less accurate).
        forceLocationManager: false,
      );
    }
    if (Platform.isIOS) {
      return AppleSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        // Keep updates flowing during the stable-fix window; the caller
        // cancels the stream once a good fix is found.
        pauseLocationUpdatesAutomatically: false,
      );
    }
    return LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    );
  }
}
