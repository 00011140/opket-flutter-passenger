import 'package:equatable/equatable.dart';
import 'package:opket/models/driver_location.dart';
import 'package:opket/models/ride_model.dart';

enum RideStatus { idle, pending, cancelled, accepted, arrived, started }

class CurrentRideState extends Equatable {
  final String? rideId;
  final RideStatus status;
  final DriverModel? driver;
  final DriverLocation? location;

  const CurrentRideState({
    this.rideId,
    this.status = RideStatus.idle,
    this.driver,
    this.location,
  });

  CurrentRideState copyWith({
    String? rideId,
    RideStatus? status,
    DriverModel? driver,
    DriverLocation? location,
  }) {
    return CurrentRideState(
      rideId: rideId ?? this.rideId,
      status: status ?? this.status,
      driver: driver ?? this.driver,
      location: location ?? this.location,
    );
  }

  /// Serialize to Map
  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
      'status': status.name, // enum -> String
      'driver': driver?.toMap(), // nullable
      'location': location?.toMap(), // nullable
    };
  }

  /// Deserialize from Map
  factory CurrentRideState.fromMap(Map<String, dynamic> map) {
    return CurrentRideState(
      rideId: map['rideId'] as String?,
      status: RideStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => RideStatus.pending,
      ),
      driver: map['driver'] != null ? DriverModel.fromMap(map['driver']) : null,
      location: map['location'] != null
          ? DriverLocation.fromMap(map['location'])
          : null,
    );
  }

  @override
  List<Object?> get props => [rideId, status, driver, location];
}
