import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/models/menu_item_model.dart';
import 'package:opket/feat/food/services/menu_item_cache.dart';
import 'package:opket/feat/food/services/restaurant_service.dart';

part 'menu_items_state.dart';

class MenuItemsParams {
  final String restaurantId;
  final String categoryId;

  MenuItemsParams({required this.restaurantId, required this.categoryId});
}

typedef MenuItemsByCategoryState = Map<String, MenuItemsState>;

class MenuItemsCubit extends Cubit<MenuItemsByCategoryState> {
  MenuItemsCubit() : super(const {});

  Future<void> loadData(MenuItemsParams params) async {
    final key = params.categoryId;

    // If already loading or loaded, don’t refetch (optional but recommended)
    final current = state[key];
    if (current is MenuItemsLoading || current is MenuItemsLoaded) return;

    try {
      // 1) Cache first
      final cached = await MenuItemCache.load(params);
      if (cached.isNotEmpty) {
        emit({...state, key: MenuItemsLoaded(cached)});
      } else {
        emit({...state, key: const MenuItemsLoading()});
      }

      // 2) Network
      final data = await RestaurantService().getMenuItems(params);
      emit({...state, key: MenuItemsLoaded(data)});
    } catch (e) {
      // emit({...state, key: MenuItemsError(e.toString())});
    }
  }

  void resetCategory(String categoryId) {
    final next = {...state}..remove(categoryId);
    emit(next);
  }

  void resetAll() {
    emit(const {});
  }
}
