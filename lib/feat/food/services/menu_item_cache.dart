import 'dart:convert';
import 'package:opket/feat/food/cubit/menu_items_cubit.dart';
import 'package:opket/feat/food/models/menu_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuItemCache {
  static String _key(String restaurantId, String categoryId) =>
      'menu_items_$restaurantId-$categoryId';

  /// Save menu items for a restaurant
  static Future<void> save({
    required String restaurantId,
    required String categoryId,
    required List<MenuItemModel> items,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = items.map((e) => e.toJson()).toList();
    await prefs.setString(_key(restaurantId, categoryId), jsonEncode(jsonList));
  }

  /// Load menu items for a restaurant
  static Future<List<MenuItemModel>> load(MenuItemsParams params) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(
      _key(params.restaurantId, params.categoryId),
    );

    if (cachedData == null) return [];

    final List decoded = jsonDecode(cachedData);
    return decoded.map((json) => MenuItemModel.fromJson(json)).toList();
  }

  /// Clear menu items cache for a restaurant
  static Future<void> clear({
    required String restaurantId,
    required String categoryId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(restaurantId, categoryId));
  }

  /// Clear ALL menu items cache (all restaurants)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('menu_items_'));

    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Check if cache exists for restaurant
  static Future<bool> hasCache({
    required String restaurantId,
    required String categoryId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key(restaurantId, categoryId));
  }
}
