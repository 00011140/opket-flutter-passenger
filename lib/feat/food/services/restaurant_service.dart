import 'package:opket/core/admin_env.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/auth_storage.dart';
import 'package:opket/feat/food/cubit/menu_items_cubit.dart';
import 'package:opket/feat/food/models/category_model.dart';
import 'package:opket/feat/food/models/menu_item_model.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:opket/feat/food/services/menu_item_cache.dart';
import 'package:opket/feat/food/services/restaurant_categories_cache.dart';
import 'package:opket/feat/food/services/restaurants_cache.dart';
import 'package:opket/core/services/api_client.dart';

class RestaurantService {
  final ApiClient client = ApiClient(
    baseUrl: AdminEnv.baseUrl,
    tokenStorage: sl<AuthStorage>(),
  );

  Future<List<CategoryModel>> getCategories(String restaurantId) async {
    try {
      final response = await client.get(
        "/menu/restaurants/$restaurantId/categories",
      );
      final List categoriesRaw = response.data['categories'];

      final categories = categoriesRaw
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      final sorted = [...categories]
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      await RestaurantCategoryCache.save(
        restaurantId: restaurantId,
        categories: sorted,
      );

      return sorted;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RestaurantModel>> getRestaurants(String restaurantId) async {
    try {
      final response = await client.get("/restaurants");
      final List rawData = response.data['restaurants'];

      final data = rawData.map((e) => RestaurantModel.fromJson(e)).toList();

      await RestaurantCache.save(data);

      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MenuItemModel>> getMenuItems(MenuItemsParams params) async {
    try {
      final response = await client.get(
        "/menu/restaurants/${params.restaurantId}/items",
        query: {'categoryId': params.categoryId},
      );
      final List rawData = response.data['items'];

      final data = rawData.map((e) => MenuItemModel.fromJson(e)).toList();

      await MenuItemCache.save(
        restaurantId: params.restaurantId,
        categoryId: params.categoryId,
        items: data,
      );

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
