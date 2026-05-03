part of 'ride_map_cubit.dart';

class RideMapState {
  final bool isReady;
  final bool isLoading;
  final bool mapMoving;
  final bool mapEnabled;
  final bool isUserLocation;
  final LatLng? currentLocation;
  final List<LatLng> animatedRoute;
  final LatLng? selectedLocation;
  final Set<Marker> markers;

  const RideMapState({
    this.isReady = false,
    this.mapMoving = false,
    this.isUserLocation = true,
    this.isLoading = true,
    this.mapEnabled = true,
    this.currentLocation,
    this.selectedLocation,
    this.animatedRoute = const [],
    this.markers = const {},
  });

  RideMapState copyWith({
    bool? isReady,
    bool? isUserLocation,
    bool? isLoading,
    bool? mapMoving,
    bool? mapEnabled,
    LatLng? currentLocation,
    LatLng? selectedLocation,
    Set<Marker>? markers,
    List<LatLng>? animatedRoute,
  }) {
    return RideMapState(
      mapMoving: mapMoving ?? this.mapMoving,
      isReady: isReady ?? this.isReady,
      isUserLocation: isUserLocation ?? this.isUserLocation,
      isLoading: isLoading ?? this.isLoading,
      mapEnabled: mapEnabled ?? this.mapEnabled,
      currentLocation: currentLocation ?? this.currentLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      markers: markers ?? this.markers,
      animatedRoute: animatedRoute ?? this.animatedRoute,
    );
  }
}
