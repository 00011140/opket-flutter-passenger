import 'package:opket/feat/food/models/cart_item.dart';
import 'package:opket/feat/food/models/menu_item_model.dart';

class ActiveOrder {
  final String id;
  final String restaurantId;
  final List<CartItem> items;
  final int subtotal;
  final int? deliveryFee;
  final DateTime createdAt;

  ActiveOrder({
    required this.id,
    required this.restaurantId,
    required this.items,
    required this.subtotal,
    required this.createdAt,
    this.deliveryFee,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "restaurantId": restaurantId,
      "items": items
          .map(
            (e) => {
              "item": e.item.toJson(),
              "quantity": e.quantity,
              "note": e.note,
            },
          )
          .toList(),
      "subtotal": subtotal,
      "deliveryFee": deliveryFee,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory ActiveOrder.fromJson(Map<String, dynamic> json) {
    return ActiveOrder(
      id: json["id"],
      restaurantId: json["restaurantId"],
      items: (json["items"] as List)
          .map(
            (e) => CartItem(
              item: MenuItemModel.fromJson(e["item"]),
              quantity: e["quantity"],
              note: e["note"],
            ),
          )
          .toList(),
      subtotal: json["subtotal"],
      deliveryFee: json["deliveryFee"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
