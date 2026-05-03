part of '../../index.dart';

sealed class RideEvent {}

class RideCreated extends RideEvent {
  final String rideId;
  RideCreated(this.rideId);
}

class RideAccepted extends RideEvent {
  final DriverModel driver;
  final DriverLocation location;

  RideAccepted({required this.driver, required this.location});
}

class DriverLocationUpdated extends RideEvent {
  final List<DriverLocation> data;
  DriverLocationUpdated(this.data);
}

class RouteUpdated extends RideEvent {
  final RouteUpdate data;

  RouteUpdated({required this.data});
}

class DriverArrived extends RideEvent {}

class RideStarted extends RideEvent {}

class RideCompleted extends RideEvent {}

class NoDriversFound extends RideEvent {}

class OnRideProgress extends RideEvent {
  final RideProgress data;
  OnRideProgress(this.data);
}

class OnDriverLocation extends RideEvent {
  final DriverLocation data;
  OnDriverLocation(this.data);
}
