part of '../../index.dart';

abstract class RideOptionsState {}

class RideOptionsInitial extends RideOptionsState {}

class RideOptionsLoading extends RideOptionsState {}

class RideOptionsSuccess extends RideOptionsState {
  final List<RideOption> options;

  RideOptionsSuccess({required this.options});
}

class RideOptionsError extends RideOptionsState {
  final String message;

  RideOptionsError({required this.message});
}
