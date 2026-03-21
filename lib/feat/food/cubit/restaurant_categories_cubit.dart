import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/models/category_model.dart';
import 'package:opket/feat/food/services/restaurant_categories_cache.dart';
import 'package:opket/feat/food/services/restaurant_service.dart';

part 'restaurant_categories_state.dart';

class RestaurantCategoriesCubit extends Cubit<RestaurantCategoriesState> {
  RestaurantCategoriesCubit() : super(RestaurantCategoriesInitial());

  Future<void> loadData(String restaurantId) async {
    try {
      final dataCashed = await RestaurantCategoryCache.load(restaurantId);
      if (dataCashed.isNotEmpty) {
        emit(RestaurantCategoriesLoaded(dataCashed));
      }
      if (dataCashed.isEmpty) emit(RestaurantCategoriesLoading());

      final data = await RestaurantService().getCategories(restaurantId);
      emit(RestaurantCategoriesLoaded(data));
    } catch (e) {
      emit(RestaurantCategoriesError(e.toString()));
    }
  }

  void reset() {
    emit(RestaurantCategoriesInitial());
  }
}
