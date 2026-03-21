import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/models/cuisine_type_model.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:opket/feat/food/services/cuisine_type_cache.dart';
import 'package:opket/feat/food/services/food_service.dart';
import 'package:opket/feat/food/services/restaurants_cache.dart';

part 'restaurants_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  RestaurantsCubit() : super(RestaurantsInitial());

  final List<RestaurantModel> _allRestaurants = [];
  final List<CuisineTypeModel> _allCuisines = [];

  String _query = '';

  Future<void> loadData() async {
    try {
      final cachedRestaurants = await RestaurantCache.load();
      final cachedCuisines = await CuisineTypeCache.load();

      if (cachedRestaurants.isEmpty && cachedCuisines.isEmpty) {
        emit(RestaurantsLoading());
      } else {
        _setRestaurants(cachedRestaurants);
        _setCuisines(cachedCuisines);
        emit(_loaded());
      }

      final freshRestaurants = await FoodService().getRestaurants();
      final freshCuisines = await FoodService().getCuisinetypes();

      _setRestaurants(freshRestaurants);
      _setCuisines(freshCuisines);

      emit(_loaded());
    } catch (e) {
      // emit(RestaurantsError(e.toString()));
    }
  }

  void setQuery(String value) {
    _query = value.trim();
    if (_allRestaurants.isEmpty) return;
    emit(_loaded());
  }

  void clearQuery() {
    _query = '';
    if (_allRestaurants.isEmpty) return;
    emit(_loaded());
  }

  RestaurantsLoaded _loaded() {
    return RestaurantsLoaded(
      restaurants: _applyFilter(),
      cuisines: List.unmodifiable(_allCuisines),
      query: _query,
    );
  }

  void _setRestaurants(List<RestaurantModel> data) {
    _allRestaurants
      ..clear()
      ..addAll(data);
  }

  void _setCuisines(List<CuisineTypeModel> data) {
    _allCuisines
      ..clear()
      ..addAll(data);
    _allCuisines.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<RestaurantModel> _applyFilter() {
    if (_query.isEmpty) return List.unmodifiable(_allRestaurants);

    final q = _query.toLowerCase();

    return _allRestaurants
        .where((r) {
          final name = r.name.toLowerCase();
          final tagsText = (r.tags ?? const <String>[]).join(' ').toLowerCase();
          return name.contains(q) || tagsText.contains(q);
        })
        .toList(growable: false);
  }
}
