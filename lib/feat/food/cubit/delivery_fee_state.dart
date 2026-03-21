part of 'delivery_fee_cubit.dart';

abstract class DeliveryFeeState {}

class DeliveryFeeInitial extends DeliveryFeeState {}

class DeliveryFeeLoading extends DeliveryFeeState {}

class DeliveryFeeLoaded extends DeliveryFeeState {
  final int data;
  DeliveryFeeLoaded(this.data);
}

class DeliveryFeeError extends DeliveryFeeState {
  final String message;
  DeliveryFeeError(this.message);
}
