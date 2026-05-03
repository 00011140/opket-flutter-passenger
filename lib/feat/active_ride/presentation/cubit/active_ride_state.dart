part of '../../index.dart';

enum RideStatus {
  idle,
  searching,
  cancelled,
  accepted,
  arrived,
  started,
  completed,
}

class ActiveRideState extends Equatable {
  final String? rideId;
  final RideStatus status;
  final DriverModel? driver;
  final RideProgress progress;
  final List<DriverLocation>? candidateDrivers;
  final DriverLocation? location;
  final LatLng? pickupLocation;
  final RouteUpdate? routeUpdate;

  const ActiveRideState({
    this.rideId,
    this.status = RideStatus.idle,
    this.driver,
    required this.progress,
    this.routeUpdate,
    this.location,
    this.pickupLocation,
    this.candidateDrivers,
  });

  ActiveRideState copyWith({
    String? rideId,
    RideStatus? status,
    RideProgress? progress,
    DriverModel? driver,
    DriverLocation? location,
    LatLng? pickupLocation,
    RouteUpdate? routeUpdate,
    List<DriverLocation>? candidateDrivers,
  }) {
    return ActiveRideState(
      routeUpdate: routeUpdate ?? this.routeUpdate,
      progress: progress ?? this.progress,
      rideId: rideId ?? this.rideId,
      status: status ?? this.status,
      driver: driver ?? this.driver,
      location: location ?? this.location,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      candidateDrivers: candidateDrivers ?? this.candidateDrivers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
      'status': status.name,
      'driver': driver?.toMap(),
      'location': location?.toMap(),
      'routeUpdate': routeUpdate?.toJson(),
      'progress': progress.toJson(),
      'pickupLocation': pickupLocation != null
          ? {
              'latitude': pickupLocation!.latitude,
              'longitude': pickupLocation!.longitude,
            }
          : null,
    };
  }

  factory ActiveRideState.fromMap(Map<String, dynamic> map) {
    return ActiveRideState(
      rideId: map['rideId'] as String?,
      status: RideStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => RideStatus.searching,
      ),
      progress: RideProgress.fromJson(map['progress']),

      routeUpdate: map['routeUpdate'] != null
          ? RouteUpdate.fromJson(map['routeUpdate'])
          : null,

      driver: map['driver'] != null ? DriverModel.fromMap(map['driver']) : null,

      location: map['location'] != null
          ? DriverLocation.fromMap(map['location'])
          : null,

      pickupLocation: map['pickupLocation'] != null
          ? LatLng(
              map['pickupLocation']['latitude'],
              map['pickupLocation']['longitude'],
            )
          : null,
    );
  }
  @override
  List<Object?> get props => [
    rideId,
    progress,
    status,
    driver,
    location,
    pickupLocation,
    routeUpdate,
    candidateDrivers,
  ];
}
