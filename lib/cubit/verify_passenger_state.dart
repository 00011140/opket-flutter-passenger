part of 'verify_passenger_cubit.dart';

abstract class VerifyPassengerState {}

class VerifyPassengerInitial extends VerifyPassengerState {}

class VerifyPassengerLoading extends VerifyPassengerState {}

class VerifyPassengerError extends VerifyPassengerState {
  final String message;
  VerifyPassengerError({required this.message});
}

class VerifyPassengerSuccess extends VerifyPassengerState {}
