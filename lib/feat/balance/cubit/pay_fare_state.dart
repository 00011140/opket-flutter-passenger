part of 'pay_fare_cubit.dart';

abstract class PayFareState {}

class PayFareInitial extends PayFareState {}

class PayFareLoading extends PayFareState {}

class PayFareSuccess extends PayFareState {}

class PayFareError extends PayFareState {
  final String message;
  PayFareError({required this.message});
}
