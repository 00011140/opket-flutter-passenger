import 'dart:convert';
import 'package:opket/feat/food/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantCategoryCache {
  static String _key(String restaurantId) => 'categories_$restaurantId';

  /// Save categories for a restaurant
  static Future<void> save({
    required String restaurantId,
    required List<CategoryModel> categories,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = categories.map((e) => e.toJson()).toList();

    await prefs.setString(_key(restaurantId), jsonEncode(jsonList));
  }

  /// Load categories for a restaurant
  static Future<List<CategoryModel>> load(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_key(restaurantId));

    if (cachedData == null) return [];

    final List decoded = jsonDecode(cachedData);
    return decoded.map((json) => CategoryModel.fromJson(json)).toList();
  }

  /// Clear categories cache for a restaurant
  static Future<void> clear(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(restaurantId));
  }

  /// Clear ALL category caches
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith('categories_'));

    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Check if cache exists
  static Future<bool> hasCache(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_key(restaurantId));
  }
}
