import 'package:flutter/material.dart';

enum OrderStatus {
  placed,
  acceptedByRestaurant,
  preparing,
  readyForPickup,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
  cancelledByConsumer,
  cancelledByRestaurant,
  cancelledNoCourier;

  factory OrderStatus.fromStatusNextStatus(OrderStatus status) {
    switch (status) {
      case placed:
        return preparing;
      case preparing:
        return readyForPickup;
      default:
        return placed;
    }
  }
}

extension OrderStatusUI on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.placed:
        return "Yuborildi";
      case OrderStatus.preparing:
        return "Tayyorlanmoqda";
      case OrderStatus.readyForPickup:
        return "Yetkazilmoqda";
      case OrderStatus.delivered:
        return "Yetkazildi";
      case OrderStatus.cancelled:
        return "Bekor qilindi";
      default:
        return "Noma'lum";
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.readyForPickup:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.teal;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

OrderStatus orderStatusFromString(String status) {
  switch (status) {
    case "PLACED":
      return OrderStatus.placed;
    case "ACCEPTED_BY_RESTAURANT":
      return OrderStatus.acceptedByRestaurant;
    case "PREPARING":
      return OrderStatus.preparing;
    case "READY_FOR_PICKUP":
      return OrderStatus.readyForPickup;
    case "PICKED_UP":
      return OrderStatus.pickedUp;
    case "ON_THE_WAY":
      return OrderStatus.onTheWay;
    case "DELIVERED":
      return OrderStatus.delivered;
    case "CANCELLED_BY_CONSUMER":
      return OrderStatus.cancelledByConsumer;
    case "CANCELLED_BY_RESTAURANT":
      return OrderStatus.cancelledByRestaurant;
    case "CANCELLED_NO_COURIER":
      return OrderStatus.cancelledNoCourier;
    default:
      throw Exception("Unknown status: $status");
  }
}

String orderStatusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.placed:
      return "PLACED";
    case OrderStatus.acceptedByRestaurant:
      return "ACCEPTED_BY_RESTAURANT";
    case OrderStatus.preparing:
      return "PREPARING";
    case OrderStatus.readyForPickup:
      return "READY_FOR_PICKUP";
    case OrderStatus.pickedUp:
      return "PICKED_UP";
    case OrderStatus.onTheWay:
      return "ON_THE_WAY";
    case OrderStatus.delivered:
      return "DELIVERED";
    case OrderStatus.cancelled:
      return "CANCELLED";
    case OrderStatus.cancelledByConsumer:
      return "CANCELLED_BY_CONSUMER";
    case OrderStatus.cancelledByRestaurant:
      return "CANCELLED_BY_RESTAURANT";
    case OrderStatus.cancelledNoCourier:
      return "CANCELLED_NO_COURIER";
  }
}

class LatLon {
  final double lat;
  final double lon;

  LatLon({required this.lat, required this.lon});

  factory LatLon.fromJson(Map<String, dynamic> json) {
    return LatLon(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {"lat": lat, "lon": lon};
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final int quantity;
  final int subtotal;
  final int price;

  OrderItem({
    required this.menuItemId,
    required this.quantity,
    required this.name,
    required this.subtotal,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    print(" 🟢 🟢 🟢 🟢");
    print(json);
    print(json['menuItemId']);

    return OrderItem(
      menuItemId: json['menuItemId'] ?? '',
      quantity: json['quantity'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
      price: json['price'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "menuItemId": menuItemId,
      "quantity": quantity,
      "subtotal": subtotal,
      "price": price,
      "name": name,
    };
  }
}

class MenuItem {
  final String id;
  final String restaurantId;
  final String? categoryId;

  final String name;
  final String? description;
  final int price;
  final bool isAvailable;
  final String? imageUrl;
  final int sortOrder;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuItem({
    required this.id,
    required this.restaurantId,
    this.categoryId,
    required this.name,
    this.description,
    required this.price,
    required this.isAvailable,
    this.imageUrl,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      categoryId: json['categoryId'],
      name: json['name'] ?? '',
      description: json['description'],
      price: json['price'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      imageUrl: json['image_url'],
      sortOrder: json['sort_order'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt']).toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'restaurantId': restaurantId,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'price': price,
      'is_available': isAvailable,
      'image_url': imageUrl,
      'sort_order': sortOrder,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class StatusHistory {
  final OrderStatus status;
  final DateTime at;
  final String? by;
  final String? note;

  StatusHistory({required this.status, required this.at, this.by, this.note});

  factory StatusHistory.fromJson(Map<String, dynamic> json) {
    return StatusHistory(
      status: orderStatusFromString(json['status']),
      at: DateTime.parse(json['at']),
      by: json['by'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": orderStatusToString(status),
      "at": at.toIso8601String(),
      "by": by,
      "note": note,
    };
  }
}

class OrderPricing {
  final int itemsSubtotal;
  final int deliveryFee;
  final int tax;
  final int discount;
  final int total;

  OrderPricing({
    required this.itemsSubtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
  });

  factory OrderPricing.fromJson(Map<String, dynamic> json) {
    return OrderPricing(
      itemsSubtotal: json['itemsSubtotal'] ?? 0,
      deliveryFee: json['deliveryFee'] ?? 0,
      tax: json['tax'] ?? 0,
      discount: json['discount'] ?? 0,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "itemsSubtotal": itemsSubtotal,
      "deliveryFee": deliveryFee,
      "tax": tax,
      "discount": discount,
      "total": total,
    };
  }
}

class Restaurant {
  final String id;
  final String name;
  final String phone;

  Restaurant({required this.name, required this.phone, required this.id});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "phone": phone};
  }
}

class Courier {
  final String name;
  final String phone;
  final String carModel;
  final String carColor;
  final String carNumber;
  final String regionCode;

  Courier({
    required this.name,
    required this.phone,
    required this.carModel,
    required this.carColor,
    required this.carNumber,
    required this.regionCode,
  });

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
      name: json['name'] as String,
      phone: json['phone'] as String,
      carModel: json['carModel'] as String,
      carColor: json['carColor'] as String,
      carNumber: json['carNumber'] as String,
      regionCode: json['regionCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'carModel': carModel,
      'carColor': carColor,
      'carNumber': carNumber,
      'regionCode': regionCode,
    };
  }
}

class FoodOrder {
  final String id;
  final Restaurant restaurantId;
  final Courier? courierId;
  final String consumerId;
  final int consumerPhone;

  final int orderNumber;
  final String orderDate;

  final List<OrderItem> items;

  final OrderPricing pricing;

  final LatLon dropoff;
  final LatLon pickup;

  final OrderStatus status;
  final List<StatusHistory> statusHistory;

  final String? cancelReason;

  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  FoodOrder({
    required this.id,
    required this.restaurantId,
    this.courierId,
    required this.consumerId,
    required this.consumerPhone,
    required this.orderNumber,
    required this.orderDate,
    required this.items,
    required this.pricing,
    required this.dropoff,
    required this.pickup,
    required this.status,
    required this.statusHistory,
    this.cancelReason,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory FoodOrder.fromJson(Map<String, dynamic> json) {
    final itemsRaw = (json['items'] as List)
        .map((e) => OrderItem.fromJson(e))
        .toList();

    return FoodOrder(
      id: json['_id'],
      restaurantId: Restaurant.fromJson(json['restaurantId']),
      courierId: json['courierId'] != null
          ? Courier.fromJson(json['courierId'])
          : null,
      consumerId: json['consumerId'],
      consumerPhone: json['consumerPhone'],
      orderNumber: json['orderNumber'],
      orderDate: json['orderDate'],
      items: itemsRaw,
      pricing: OrderPricing.fromJson(json['pricing']),
      dropoff: LatLon.fromJson(json['dropoff']),
      pickup: LatLon.fromJson(json['pickup']),
      status: orderStatusFromString(json['status']),
      statusHistory: (json['statusHistory'] as List)
          .map((e) => StatusHistory.fromJson(e))
          .toList(),
      cancelReason: json['cancelReason'],
      isActive: json['isActive'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "restaurantId": restaurantId.toJson(),
      "courierId": courierId?.toJson(),
      "consumerId": consumerId,
      "consumerPhone": consumerPhone,
      "orderNumber": orderNumber,
      "orderDate": orderDate,
      "items": items.map((e) => e.toJson()).toList(),
      "pricing": pricing.toJson(),
      "dropoff": dropoff.toJson(),
      "pickup": pickup.toJson(),
      "status": orderStatusToString(status),
      "statusHistory": statusHistory.map((e) => e.toJson()).toList(),
      "cancelReason": cancelReason,
      "isActive": isActive,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  static String statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return "Yangi";
      case OrderStatus.preparing:
        return "Tayyorlanmoqda";
      case OrderStatus.readyForPickup:
        return "Tayyor";
      case OrderStatus.delivered:
        return "Yetkazildi";
      case OrderStatus.cancelled:
        return "Bekor qilindi";
      default:
        return "";
    }
  }

  static IconData statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Icons.fiber_new;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.readyForPickup:
        return Icons.check_circle;
      case OrderStatus.delivered:
        return Icons.local_shipping;
      case OrderStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.circle;
    }
  }

  static Color statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.readyForPickup:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.teal;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
