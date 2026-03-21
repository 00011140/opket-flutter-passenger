import 'dart:convert';
import 'package:opket/feat/food/models/cuisine_type_model.dart';
import 'package:opket/feat/food/models/food_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuisineTypeCache {
  static const String _cacheKey = 'cuisine_types';

  /// Save list to cache
  static Future<void> save(List<CuisineTypeModel> categories) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = categories.map((category) => category.toJson()).toList();

    await prefs.setString(_cacheKey, jsonEncode(jsonList));
  }

  /// Read list from cache
  static Future<List<CuisineTypeModel>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);

    if (cachedData == null) return [];

    final List decoded = jsonDecode(cachedData);
    return decoded.map((json) => CuisineTypeModel.fromJson(json)).toList();
  }

  /// Clear cache
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
