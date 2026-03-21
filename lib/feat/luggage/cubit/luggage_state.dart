part of 'luggage_cubit.dart';

abstract class LuggageState {}

class LuggageInitial extends LuggageState {}

class DriverRequestingLuggage extends LuggageState {
  final int luggageCharge;
  final String driverId;

  DriverRequestingLuggage({
    required this.luggageCharge,
    required this.driverId,
  });
}
