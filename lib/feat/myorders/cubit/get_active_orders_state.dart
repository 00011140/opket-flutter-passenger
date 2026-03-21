part of 'get_active_orders_cubit.dart';

abstract class GetActiveOrdersState {}

class GetActiveOrdersInitial extends GetActiveOrdersState {}

class GetActiveOrdersLoading extends GetActiveOrdersState {}

class GetActiveOrdersError extends GetActiveOrdersState {
  final String message;
  GetActiveOrdersError({required this.message});
}

class GetActiveOrdersSuccess extends GetActiveOrdersState {
  final List<FoodOrder> orders;

  GetActiveOrdersSuccess({required this.orders});
}
