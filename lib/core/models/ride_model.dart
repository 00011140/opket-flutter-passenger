import 'package:opket/core/models/driver_location.dart';
import 'package:opket/core/models/driver_model.dart';

class RideModel {
  final String id;
  final String status;
  final DriverModel driver;
  final DriverLocation driverLocation;

  const RideModel({
    required this.id,
    required this.status,
    required this.driver,
    required this.driverLocation,
  });

  /// Convert RideModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'driver': driver.toMap(),
      'driverLocation': driverLocation,
    };
  }

  /// Create RideModel from Map
  factory RideModel.fromMap(Map<String, dynamic> map) {
    return RideModel(
      id: map['_id'] ?? '',
      status: map['status'] ?? '',
      driver: DriverModel.fromMap(map['driverId']),
      driverLocation: DriverLocation.fromMap(map['driver_location']),
    );
  }
}
