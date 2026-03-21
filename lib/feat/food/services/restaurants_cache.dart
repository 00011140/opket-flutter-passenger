import 'dart:convert';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantCache {
  static const String _cacheKey = 'restaurants';

  /// Save list of restaurants to cache
  static Future<void> save(List<RestaurantModel> restaurants) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = restaurants
        .map((restaurant) => restaurant.toJson())
        .toList();

    await prefs.setString(_cacheKey, jsonEncode(jsonList));
  }

  /// Read list of restaurants from cache
  static Future<List<RestaurantModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);

    if (cachedData == null) return [];

    final List decoded = jsonDecode(cachedData);
    return decoded.map((json) => RestaurantModel.fromJson(json)).toList();
  }

  /// Clear restaurants cache
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  /// Check if cache exists
  static Future<bool> hasCache() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cacheKey);
  }
}
