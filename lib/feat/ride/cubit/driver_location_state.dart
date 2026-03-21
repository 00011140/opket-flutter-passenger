part of 'driver_location_cubit.dart';

abstract class DriverLocationState {}

class DriverLocationInitial extends DriverLocationState {}

class DriverLocationUpdate extends DriverLocationState {
  final DriverLocation location;

  DriverLocationUpdate({required this.location});
}
