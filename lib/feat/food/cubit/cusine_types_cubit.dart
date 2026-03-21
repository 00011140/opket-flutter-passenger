import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/models/cuisine_type_model.dart';
import 'package:opket/feat/food/services/cuisine_type_cache.dart';
import 'package:opket/feat/food/services/food_service.dart';

part 'cusine_types_state.dart';

class FoodCategoriesCubit extends Cubit<CusineTypesState> {
  FoodCategoriesCubit() : super(CuisineTypesInitial());

  Future<void> loadData() async {
    try {
      final dataCashed = await CuisineTypeCache.load();
      if (dataCashed.isNotEmpty) {
        emit(CuisineTypesLoaded(dataCashed));
      }
      if (dataCashed.isEmpty) emit(CuisineTypesLoading());

      final data = await FoodService().getCuisinetypes();
      emit(CuisineTypesLoaded(data));
    } catch (e) {
      emit(CuisineTypesError(e.toString()));
    }
  }

  void reset() {
    emit(CuisineTypesInitial());
  }
}
