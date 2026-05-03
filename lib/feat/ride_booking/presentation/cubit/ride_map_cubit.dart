import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  // ________ START DRIVER LOCATION ________
  DriverLocation? _lastDriverLocation;

  Animation<LatLng>? _positionAnimation;
  Animation<double>? _rotationAnimation;

  VoidCallback? _driverAnimListener;
  VoidCallback? _routeAnimListener;
  // ________ END DRIVER LOCATION ________

  Future<void> init() async {
    final position = await LocationService.getCurrentPosition();
    await _mapController.init();
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
        emit(state.copyWith(markers: {driverMarker, userMarker}));
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

  void onRideCancelled() {
    emit(state.copyWith(mapEnabled: true, markers: {}, animatedRoute: []));
    recenter();
  }

  @override
  Future<void> close() {
    driverController.dispose();
    routeController.dispose();
    return super.close();
  }
}
