part of 'ride_cubit.dart';

abstract class RideState {}

class RideInitial extends RideState {}

class RideRequestLoading extends RideState {}

class RideRequestSuccess extends RideState {
  final String rideId;

  RideRequestSuccess({required this.rideId});
}

class RideRequestError extends RideState {
  final String message;

  RideRequestError({required this.message});
}

class RideRequestEndCall extends RideState {}

class CancelRideLoading extends RideState {}

class CancelRideSuccess extends RideState {}

class CancelRideError extends RideState {
  final String message;

  CancelRideError({required this.message});
}
