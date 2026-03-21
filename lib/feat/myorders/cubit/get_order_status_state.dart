part of 'get_order_status_cubit.dart';

abstract class GetOrderStatusState {}

class GetOrderStatusInitial extends GetOrderStatusState {}

class GetOrderStatusLoading extends GetOrderStatusState {}

class GetOrderStatusError extends GetOrderStatusState {
  final String message;
  GetOrderStatusError({required this.message});
}

class GetOrderStatusSuccess extends GetOrderStatusState {
  final OrderStatus status;

  GetOrderStatusSuccess({required this.status});
}
