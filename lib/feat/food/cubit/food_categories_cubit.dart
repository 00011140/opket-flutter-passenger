import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/models/food_category_model.dart';
import 'package:opket/feat/food/services/food_categories_cache.dart';
import 'package:opket/feat/food/services/food_service.dart';

part 'food_categories_state.dart';

class FoodCategoriesCubit extends Cubit<FoodCategoriesState> {
  FoodCategoriesCubit() : super(FoodCategoriesInitial());

  Future<void> loadData() async {
    try {
      final dataCashed = await FoodCategoryCache.load();
      if (dataCashed.isNotEmpty) {
        emit(FoodCategoriesLoaded(dataCashed));
      }
      if (dataCashed.isEmpty) emit(FoodCategoriesLoading());

      final data = await FoodService().getCategories();
      emit(FoodCategoriesLoaded(data));
    } catch (e) {
      emit(FoodCategoriesError(e.toString()));
    }
  }

  void reset() {
    emit(FoodCategoriesInitial());
  }
}
