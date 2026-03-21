import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:opket/feat/myorders/services/order_local_storage.dart';

class ActiveOrdersCubit extends Cubit<List<FoodOrder>> {
  ActiveOrdersCubit() : super([]);

  Future<void> loadOrders() async {
    final orders = await OrderLocalStorage.getOrders();
    emit(orders);
  }

  Future<void> removeOrder(String id) async {
    await OrderLocalStorage.removeOrder(id);
    loadOrders();
  }
}
