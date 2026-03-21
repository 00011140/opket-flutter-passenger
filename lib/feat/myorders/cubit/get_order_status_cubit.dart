import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/services/food_service.dart';
import 'package:opket/feat/myorders/models/food_order.dart';

part 'get_order_status_state.dart';

class GetOrderStatusCubit extends Cubit<GetOrderStatusState> {
  GetOrderStatusCubit() : super(GetOrderStatusInitial());

  Future<void> getOrderStatus(String id) async {
    emit(GetOrderStatusLoading());
    try {
      final status = await FoodService().getOrderStatus(id);

      emit(GetOrderStatusSuccess(status: status));
    } catch (e) {
      emit(GetOrderStatusError(message: e.toString()));
    }
  }

  void reset() {
    emit(GetOrderStatusInitial());
  }
}
