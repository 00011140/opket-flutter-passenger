part of 'order_food_cubit.dart';

sealed class OrderFoodState {
  const OrderFoodState();
}

class OrderFoodInitial extends OrderFoodState {}

class OrderFoodLoading extends OrderFoodState {}

class OrderFoodSuccess extends OrderFoodState {
  final FoodOrder order;

  OrderFoodSuccess({required this.order});
}

class OrderFoodError extends OrderFoodState {
  final String message;
  const OrderFoodError(this.message);
}
