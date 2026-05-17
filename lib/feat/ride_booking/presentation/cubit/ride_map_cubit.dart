import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opket/core/models/driver_location.dart';
import 'package:opket/core/services/location_service.dart';
import 'package:opket/core/utils/distaneInMeters.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:opket/feat/dashboard/controllers/dashboard_map_controller.dart';
import 'package:opket/feat/dashboard/controllers/map_pin_controller.dart';

part 'ride_map_state.dart';

class RideMapCubit extends Cubit<RideMapState> {
  RideMapCubit() : super(const RideMapState());

  final _mapController = GoogleMapsController();
  final _pinController = MapPinController();
  late AnimationController driverController;
  late AnimationController routeController;

  GoogleMapsController get map => _mapController;
  MapPinController get pin => _pinController;

  // Guard: prevents a second init() from running while one is already in
  // flight. Without this, LocationCubit can emit LocationPermissionGranted
  // more than once (e.g. on app resume) and each emission would trigger
  // init(), causing the camera to snap back to the user's GPS location even
  // after they have dragged the map to a different pickup point.
  bool _isInitializing = false;

  // Ongoing GPS subscription started after the first stable fix.
  // Keeps _mapController.currentLocation fresh so that onCameraIdle()'s
  // "is this the user's location?" distance check stays accurate as the user
  // moves — without emitting state (no widget rebuilds from GPS ticks).
  StreamSubscription<Position>? _locationStreamSub;

  // ________ START DRIVER LOCATION ________
  DriverLocation? _lastDriverLocation;

  Animation<LatLng>? _positionAnimation;
  Animation<double>? _rotationAnimation;

  VoidCallback? _driverAnimListener;
  VoidCallback? _routeAnimListener;

  List<LatLng> _fullRoute = [];
  int _trimIndex = 0;
  // ________ END DRIVER LOCATION ________

  Future<void> init() async {
    // Skip if already initialized or a concurrent init() is running.
    // isReady guards against re-entry after a successful first init.
    if (state.isReady || _isInitializing) return;
    _isInitializing = true;

    // Wait for a stable GPS fix (accuracy ≤ 50 m) before revealing the map.
    // Using getCurrentPosition() here would return the first OS fix, which on
    // a cold GPS can be 100–500 m off (cached network/cell tower location).
    // Streaming and filtering by accuracy prevents the initial camera from
    // snapping to a wrong spot and then visibly correcting itself.
    final position = await LocationService.getStablePosition();

    // Load marker assets in parallel with the GPS wait (already started above)
    await _mapController.init();

    _isInitializing = false;

    if (position == null) return;

    final latLng = LatLng(position.latitude, position.longitude);

    _mapController.currentLocation = latLng;
    _mapController.selectedLocation = latLng;

    emit(
      state.copyWith(
        isLoading: false,
        isReady: true,
        currentLocation: latLng,
        selectedLocation: latLng,
      ),
    );

    // Begin real-time tracking now that the map is visible.
    _startLocationTracking();
  }

  // Subscribes to a filtered GPS stream (accuracy ≤ 50 m, movement ≥ 5 m).
  // Each update silently refreshes _mapController.currentLocation — the value
  // used by onCameraIdle() when computing "is map centered on user?".
  //
  // We intentionally do NOT emit() here. state.currentLocation is read only
  // once: to seed initialCameraPosition when the GoogleMap widget is created.
  // Emitting on every GPS tick would rebuild RideBookingMap every few seconds,
  // causing unnecessary marker re-renders and BlocBuilder overhead.
  void _startLocationTracking() {
    _locationStreamSub?.cancel();
    _locationStreamSub = LocationService.getAccuratePositionStream().listen(
      (position) {
        _mapController.currentLocation = LatLng(
          position.latitude,
          position.longitude,
        );
      },
    );
  }

  void initAnimation(TickerProvider vsync) {
    driverController = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: 1500),
    );

    routeController = AnimationController(
      vsync: vsync,
      duration: Duration(seconds: 2),
    );
  }

  void onCameraMove(LatLng target) {
    _mapController.updateSelectedLocation(target);
  }

  void onCameraMoveStarted() {
    _pinController.lift();
    emit(state.copyWith(mapMoving: true));
  }

  void onCameraIdle() {
    _pinController.drop();

    final distance = distanceInMeters(
      _mapController.currentLocation!,
      _mapController.selectedLocation!,
    );

    final isUserLocation = distance < 25;

    emit(
      state.copyWith(
        selectedLocation: _mapController.selectedLocation,
        isUserLocation: isUserLocation,
        mapMoving: false,
      ),
    );
  }

  void updateMarkers(Set<Marker> markers) {
    emit(state.copyWith(markers: markers));
  }

  void setMapEnabled(bool enabled) {
    emit(state.copyWith(mapEnabled: enabled));
  }

  void showCandidateDrivers(List<DriverLocation> drivers) {
    final markers = _mapController.buildDriverMarkers(drivers);

    emit(state.copyWith(markers: markers));
  }

  Future<void> showAcceptedDriver({
    required DriverLocation driverLocation,
    required LatLng pickupLocation,
  }) async {
    final driverMarker = _mapController.updateDriverMarker(driverLocation);
    final userMarker = _mapController.updateUserMarker(pickupLocation);

    if (driverMarker == null || userMarker == null) return;

    emit(state.copyWith(markers: {driverMarker, userMarker}, mapEnabled: true));

    await _mapController.fitMarkersInView(
      driverLocation: driverLocation.toLatLng(),
      pickupLocation: pickupLocation,
    );
  }

  void clearMarkers() {
    emit(state.copyWith(markers: {}));
  }

  void recenter() {
    _mapController.recenterToUser();
  }

  void animateDriverTo(DriverLocation newLoc, LatLng pickupLocation) {
    // First update: just place marker
    if (_lastDriverLocation == null) {
      _lastDriverLocation = newLoc;

      // showAcceptedDriver(
      //   driverLocation: newLoc,
      //   pickupLocation: pickupLocation,
      // );

      return;
    }

    final oldLoc = _lastDriverLocation!;

    final startPos = oldLoc.toLatLng();
    final endPos = newLoc.toLatLng();

    final startHeading = oldLoc.heading ?? 0;

    final endHeading =
        startHeading +
        shortestAngleDelta(startHeading, newLoc.heading ?? startHeading);

    driverController.stop();
    driverController.reset();

    _positionAnimation = LatLngTween(
      begin: startPos,
      end: endPos,
    ).animate(CurvedAnimation(parent: driverController, curve: Curves.linear));

    _rotationAnimation = Tween<double>(
      begin: startHeading,
      end: endHeading,
    ).animate(CurvedAnimation(parent: driverController, curve: Curves.easeOut));

    if (_driverAnimListener != null) {
      driverController.removeListener(_driverAnimListener!);
    }

    _driverAnimListener = () {
      final animatedPos = _positionAnimation!.value;

      final animatedHeading = normalizeAngle(_rotationAnimation!.value);

      final driverMarker = map.updateDriverMarker(
        DriverLocation(
          latitude: animatedPos.latitude,
          longitude: animatedPos.longitude,
          heading: animatedHeading,
        ),
      );

      final userMarker = map.updateUserMarker(pickupLocation);

      if (driverMarker != null && userMarker != null) {
        emit(state.copyWith(
          markers: {driverMarker, userMarker},
          animatedRoute: _trimmedRouteForDriver(animatedPos),
        ));
      }
    };

    driverController.addListener(_driverAnimListener!);

    driverController.forward();

    _lastDriverLocation = newLoc;
  }

  double normalizeAngle(double angle) {
    return (angle % 360 + 360) % 360;
  }

  double shortestAngleDelta(double from, double to) {
    return (to - from + 540) % 360 - 180;
  }

  void startAnimation(List<LatLng> route) {
    _fullRoute = route;
    _trimIndex = 0;

    routeController.stop();
    routeController.reset();

    if (_routeAnimListener != null) {
      routeController.removeListener(_routeAnimListener!);
    }

    _routeAnimListener = () {
      _listener(route);
    };

    routeController.addListener(_routeAnimListener!);

    routeController.forward();
  }

  void _listener(List<LatLng> route) {
    // final route = state.fullRoute;
    if (route.isEmpty) return;

    double t = Curves.easeInOut.transform(routeController.value);
    int index = (t * (route.length - 1)).floor();

    if (index < route.length - 1) {
      emit(state.copyWith(animatedRoute: route.sublist(0, index + 1)));
    } else {
      emit(
        state.copyWith(
          animatedRoute: route, // ✅ full route
        ),
      );
    }
  }

  // Returns the route trimmed up to the closest point ahead of _trimIndex,
  // or null if the driver hasn't advanced to the next point yet.
  List<LatLng>? _trimmedRouteForDriver(LatLng driverPos) {
    if (_fullRoute.isEmpty || _trimIndex >= _fullRoute.length) return null;

    int best = _trimIndex;
    double bestDist = _approxDistSq(driverPos, _fullRoute[_trimIndex]);

    for (int i = _trimIndex + 1; i < _fullRoute.length; i++) {
      final d = _approxDistSq(driverPos, _fullRoute[i]);
      if (d < bestDist) {
        bestDist = d;
        best = i;
      }
    }

    if (best <= _trimIndex) return null;
    _trimIndex = best;
    return _fullRoute.sublist(_trimIndex);
  }

  double _approxDistSq(LatLng a, LatLng b) {
    final dlat = a.latitude - b.latitude;
    final dlng = a.longitude - b.longitude;
    return dlat * dlat + dlng * dlng;
  }

  void onRideCancelled() {
    _fullRoute = [];
    _trimIndex = 0;
    emit(state.copyWith(mapEnabled: true, markers: {}, animatedRoute: []));
    recenter();
  }

  @override
  Future<void> close() {
    _locationStreamSub?.cancel();
    driverController.dispose();
    routeController.dispose();
    return super.close();
  }
}
