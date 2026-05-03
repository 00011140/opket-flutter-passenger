part of 'ride_booking_cubit.dart';

abstract class RideBookingState {}

class RideInitial extends RideBookingState {}

// REQUEST RIDE
class RequestRideLoading extends RideBookingState {}

class RequestRideSuccess extends RideBookingState {
  final String rideId;

  RequestRideSuccess({required this.rideId});
}

class RequestRideError extends RideBookingState {
  final String message;

  RequestRideError({required this.message});
}

// CANCEL RIDE
class CancelRideLoading extends RideBookingState {}

class CancelRideSuccess extends RideBookingState {}

class CancelRideError extends RideBookingState {
  final String message;

  CancelRideError({required this.message});
}
