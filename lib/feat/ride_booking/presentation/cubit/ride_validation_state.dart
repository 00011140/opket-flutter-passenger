part of 'ride_validation_cubit.dart';

abstract class RideValidationState {}

class RideValidationInitial extends RideValidationState {}

class NoInternet extends RideValidationState {}

class NotAuthenticated extends RideValidationState {}

class LocationServicesNotEnabled extends RideValidationState {}

class LocationPermissionDenied extends RideValidationState {}

class LocationPermissionDeniedForever extends RideValidationState {}

class NotCurrentUserLocation extends RideValidationState {}

class RideValidationSuccess extends RideValidationState {}
