import 'dart:convert';

import 'package:opket/feat/food/models/order_model.dart';
import 'package:opket/feat/food/models/orders_list_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple cache service using SharedPreferences.
/// Stores current list of orders as JSON string.
class OrdersCacheService {
  static const String _kOrdersKey = 'cached_orders_v1';

  const OrdersCacheService();

  Future<void> saveOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode(OrdersState(orders: orders).toJson());
    await prefs.setString(_kOrdersKey, payload);
  }

  Future<List<Order>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kOrdersKey);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return OrdersState.fromJson(decoded).orders;
    } catch (_) {
      // If schema changes or data corrupt, fail safe to empty.
      return const [];
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kOrdersKey);
  }

  /// Optional: quick check without fully decoding.
  Future<bool> hasCachedOrders() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_kOrdersKey);
  }
}
