import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/services/food_service.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:opket/feat/myorders/services/order_local_storage.dart';

part 'get_active_orders_state.dart';

class GetActiveOrdersCubit extends Cubit<GetActiveOrdersState> {
  GetActiveOrdersCubit() : super(GetActiveOrdersInitial());

  Future<void> getActiveOrders() async {
    emit(GetActiveOrdersLoading());
    try {
      final ordersCashed = await OrderLocalStorage.getOrders();
      emit(GetActiveOrdersSuccess(orders: ordersCashed));

      final orders = await FoodService().getActiveOrders();
      await OrderLocalStorage.saveOrders(orders);

      emit(GetActiveOrdersSuccess(orders: orders));
    } catch (e) {
      print(" ⚠️ ⚠️ ⚠️");
      print(e.toString());
      emit(GetActiveOrdersError(message: e.toString()));
    }
  }

  void reset() {
    emit(GetActiveOrdersInitial());
  }
}
