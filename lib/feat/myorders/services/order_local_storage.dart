import 'dart:convert';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderLocalStorage {
  static const _key = "active_orders";

  static Future<List<FoodOrder>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);

    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List;

    return decoded.map((e) => FoodOrder.fromJson(e)).toList();
  }

  static Future<void> saveOrder(FoodOrder order) async {
    final prefs = await SharedPreferences.getInstance();

    final orders = await getOrders();

    orders.add(order);

    final encoded = jsonEncode(orders.map((e) => e.toJson()).toList());

    await prefs.setString(_key, encoded);
  }

  static Future<void> saveOrders(List<FoodOrder> orders) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(orders.map((e) => e.toJson()).toList());

    await prefs.setString(_key, encoded);
  }

  static Future<void> removeOrder(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final orders = await getOrders();

    orders.removeWhere((o) => o.id == id);

    await prefs.setString(
      _key,
      jsonEncode(orders.map((e) => e.toJson()).toList()),
    );
  }
}
