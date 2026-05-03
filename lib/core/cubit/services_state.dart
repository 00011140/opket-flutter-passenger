part of 'services_cubit.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesInitSuccess extends ServicesState {}

class ServicesInitError extends ServicesState {
  final String message;

  ServicesInitError({required this.message});
}
