import 'order_model.dart';

/// Holds a list of orders (plus convenient helpers).
class OrdersState {
  final List<Order> orders;

  const OrdersState({required this.orders});

  factory OrdersState.empty() => const OrdersState(orders: []);

  factory OrdersState.fromJson(Map<String, dynamic> json) {
    final list = (json['orders'] as List<dynamic>? ?? const [])
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return OrdersState(orders: list);
  }

  Map<String, dynamic> toJson() => {
    'orders': orders.map((o) => o.toJson()).toList(growable: false),
  };

  OrdersState copyWith({List<Order>? orders}) =>
      OrdersState(orders: orders ?? this.orders);

  /// Optional convenience helpers
  List<Order> get activeOrders => orders.where((o) => o.isActive).toList();
  Order? byId(String id) {
    for (final o in orders) {
      if (o.id == id) return o;
    }
    return null;
  }

  OrdersState upsert(Order order) {
    final idx = orders.indexWhere((o) => o.id == order.id);
    if (idx == -1) {
      return OrdersState(orders: [...orders, order]);
    }
    final next = [...orders];
    next[idx] = order;
    return OrdersState(orders: next);
  }

  OrdersState removeById(String id) =>
      OrdersState(orders: orders.where((o) => o.id != id).toList());
}
