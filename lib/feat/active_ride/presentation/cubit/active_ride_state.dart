part of '../../index.dart';

enum RideStatus {
  idle,
  searching,
  cancelled,
  accepted,
  arrived,
  started,
  completed;

  static RideStatus fromString(String? value) {
    if (value == null) return RideStatus.idle;

    // normalize (optional but safer)
    final normalized = value.toLowerCase();

    // custom rule
    if (normalized == 'completed') {
      return RideStatus.idle;
    }

    return RideStatus.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => RideStatus.idle,
    );
  }
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
  final int searchDurationMs;
  final int? searchStartedAtMs; // epoch ms when search started

  const ActiveRideState({
    this.rideId,
    this.status = RideStatus.idle,
    this.driver,
    required this.progress,
    this.routeUpdate,
    this.location,
    this.pickupLocation,
    this.candidateDrivers,
    this.searchDurationMs = 3 * 60 * 1000,
    this.searchStartedAtMs,
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
    int? searchDurationMs,
    int? searchStartedAtMs,
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
      searchDurationMs: searchDurationMs ?? this.searchDurationMs,
      searchStartedAtMs: searchStartedAtMs ?? this.searchStartedAtMs,
    );
  }

  /// Remaining search duration in milliseconds (may be negative if expired).
  int get searchRemainingMs {
    final startedAt = searchStartedAtMs;
    if (startedAt == null) return searchDurationMs;
    final elapsed = DateTime.now().millisecondsSinceEpoch - startedAt;
    return (searchDurationMs - elapsed).clamp(0, searchDurationMs);
  }

  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
      'status': status.name,
      'driver': driver?.toMap(),
      'location': location?.toMap(),
      'routeUpdate': routeUpdate?.toJson(),
      'progress': progress.toJson(),
      'searchDurationMs': searchDurationMs,
      'searchStartedAtMs': searchStartedAtMs,
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
      status: RideStatus.fromString(map['status']),
      progress: RideProgress.fromJson(map['progress']),
      routeUpdate: map['routeUpdate'] != null
          ? RouteUpdate.fromJson(map['routeUpdate'])
          : null,
      driver: map['driver'] != null ? DriverModel.fromMap(map['driver']) : null,
      location: map['location'] != null
          ? DriverLocation.fromMap(map['location'])
          : null,
      searchDurationMs: (map['searchDurationMs'] as num?)?.toInt() ?? 3 * 60 * 1000,
      searchStartedAtMs: (map['searchStartedAtMs'] as num?)?.toInt(),
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
    searchDurationMs,
    searchStartedAtMs,
  ];
}
