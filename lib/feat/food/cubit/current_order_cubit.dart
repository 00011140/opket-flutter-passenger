import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/models/order_model.dart';
import 'package:opket/feat/food/services/orders_cache_service.dart';

class CurrentOrderCubit extends Cubit<List<Order>> {
  CurrentOrderCubit() : super([]);

  Future<void> restoreOrder() async {
    final savedState = await OrdersCacheService().loadOrders();
    if (savedState.isNotEmpty) {
      emit(savedState);
    }
  }

  void reset() {
    emit([]);
  }
}
