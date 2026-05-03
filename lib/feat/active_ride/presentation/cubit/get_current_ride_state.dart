part of '../../index.dart';

abstract class GetCurrentRideState {}

class GetCurrentRideInitial extends GetCurrentRideState {}

class GetCurrentRideLoading extends GetCurrentRideState {}

class GetCurrentRideSuccess extends GetCurrentRideState {
  final RideModel ride;

  GetCurrentRideSuccess({required this.ride});
}

class GetCurrentRideError extends GetCurrentRideState {
  final String message;

  GetCurrentRideError({required this.message});
}
