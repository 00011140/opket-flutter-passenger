import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';

class CurrentRestaurantCubit extends Cubit<RestaurantModel> {
  CurrentRestaurantCubit() : super(RestaurantModel.empty());

  Future<void> setData(RestaurantModel data) async {
    emit(data);
  }
}
