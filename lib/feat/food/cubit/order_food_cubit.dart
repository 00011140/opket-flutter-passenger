import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/cart_state.dart';
import 'package:opket/feat/food/services/food_service.dart';
import 'package:opket/feat/myorders/models/food_order.dart';

part 'order_food_state.dart';

class OrderFoodCubit extends Cubit<OrderFoodState> {
  OrderFoodCubit() : super(OrderFoodInitial());

  Future<void> orderFood(CartState state) async {
    try {
      emit(OrderFoodLoading());
      final order = await FoodService().orderfood(state);
      emit(OrderFoodSuccess(order: order));
    } catch (e) {
      emit(OrderFoodError(e.toString()));
    }
  }

  void reset() {
    emit(OrderFoodInitial());
  }
}
