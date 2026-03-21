// Dart data classes for your Order MongoDB model.
// Assumptions:
// - ObjectId is represented as String in the app layer.
// - Dates are ISO-8601 strings in JSON (DateTime.parse / toIso8601String).
// - Includes createdAt/updatedAt from { timestamps: true }.

enum OrderStatus {
  placed,
  acceptedByRestaurant,
  preparing,
  readyForPickup,
  pickedUp,
  onTheWay,
  delivered,
  cancelledByConsumer,
  cancelledByRestaurant,
  cancelledNoCourier,
}

extension OrderStatusX on OrderStatus {
  static OrderStatus fromWire(String v) {
    switch (v) {
      case 'PLACED':
        return OrderStatus.placed;
      case 'ACCEPTED_BY_RESTAURANT':
        return OrderStatus.acceptedByRestaurant;
      case 'PREPARING':
        return OrderStatus.preparing;
      case 'READY_FOR_PICKUP':
        return OrderStatus.readyForPickup;
      case 'PICKED_UP':
        return OrderStatus.pickedUp;
      case 'ON_THE_WAY':
        return OrderStatus.onTheWay;
      case 'DELIVERED':
        return OrderStatus.delivered;
      case 'CANCELLED_BY_CONSUMER':
        return OrderStatus.cancelledByConsumer;
      case 'CANCELLED_BY_RESTAURANT':
        return OrderStatus.cancelledByRestaurant;
      case 'CANCELLED_NO_COURIER':
        return OrderStatus.cancelledNoCourier;
      default:
        throw ArgumentError('Unknown OrderStatus wire value: $v');
    }
  }

  String toWire() {
    switch (this) {
      case OrderStatus.placed:
        return 'PLACED';
      case OrderStatus.acceptedByRestaurant:
        return 'ACCEPTED_BY_RESTAURANT';
      case OrderStatus.preparing:
        return 'PREPARING';
      case OrderStatus.readyForPickup:
        return 'READY_FOR_PICKUP';
      case OrderStatus.pickedUp:
        return 'PICKED_UP';
      case OrderStatus.onTheWay:
        return 'ON_THE_WAY';
      case OrderStatus.delivered:
        return 'DELIVERED';
      case OrderStatus.cancelledByConsumer:
        return 'CANCELLED_BY_CONSUMER';
      case OrderStatus.cancelledByRestaurant:
        return 'CANCELLED_BY_RESTAURANT';
      case OrderStatus.cancelledNoCourier:
        return 'CANCELLED_NO_COURIER';
    }
  }
}

/// Client sends: { menuItemId: string, quantity: number }
class MenuItemType {
  final String menuItemId;
  final int quantity;

  const MenuItemType({required this.menuItemId, required this.quantity});

  factory MenuItemType.fromJson(Map<String, dynamic> json) {
    return MenuItemType(
      menuItemId: json['menuItemId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'menuItemId': menuItemId,
    'quantity': quantity,
  };

  MenuItemType copyWith({String? menuItemId, int? quantity}) => MenuItemType(
    menuItemId: menuItemId ?? this.menuItemId,
    quantity: quantity ?? this.quantity,
  );
}

class LatLon {
  final double lat;
  final double lon;

  const LatLon({required this.lat, required this.lon});

  factory LatLon.fromJson(Map<String, dynamic> json) {
    return LatLon(
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'lat': lat, 'lon': lon};

  LatLon copyWith({double? lat, double? lon}) =>
      LatLon(lat: lat ?? this.lat, lon: lon ?? this.lon);
}

class OrderItem {
  final String menuItemId;
  final int quantity;

  const OrderItem({required this.menuItemId, required this.quantity});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItemId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'menuItemId': menuItemId,
    'quantity': quantity,
  };

  OrderItem copyWith({String? menuItemId, int? quantity}) => OrderItem(
    menuItemId: menuItemId ?? this.menuItemId,
    quantity: quantity ?? this.quantity,
  );
}

class StatusHistoryEntry {
  final OrderStatus status;
  final DateTime at;
  final String? by; // ObjectId string
  final String? note;

  const StatusHistoryEntry({
    required this.status,
    required this.at,
    this.by,
    this.note,
  });

  factory StatusHistoryEntry.fromJson(Map<String, dynamic> json) {
    return StatusHistoryEntry(
      status: OrderStatusX.fromWire(json['status'] as String),
      at: DateTime.parse(json['at'] as String),
      by: json['by'] as String?,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status.toWire(),
    'at': at.toIso8601String(),
    if (by != null) 'by': by,
    if (note != null) 'note': note,
  };

  StatusHistoryEntry copyWith({
    OrderStatus? status,
    DateTime? at,
    String? by,
    String? note,
  }) => StatusHistoryEntry(
    status: status ?? this.status,
    at: at ?? this.at,
    by: by ?? this.by,
    note: note ?? this.note,
  );
}

class Order {
  final String id; // _id
  final String restaurantId;
  final String? courierId; // nullable (can be null)
  final String consumerId;

  final List<OrderItem> items;
  final LatLon dropoff;
  final LatLon pickup;

  final OrderStatus status;
  final List<StatusHistoryEntry> statusHistory;

  final String? cancelReason;
  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Order({
    required this.id,
    required this.restaurantId,
    required this.courierId,
    required this.consumerId,
    required this.items,
    required this.dropoff,
    required this.pickup,
    required this.status,
    required this.statusHistory,
    required this.cancelReason,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: (json['_id'] ?? json['id']) as String,
      restaurantId: json['restaurantId'] as String,
      courierId: json['courierId'] as String?,
      consumerId: json['consumerId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
      dropoff: LatLon.fromJson(json['dropoff'] as Map<String, dynamic>),
      pickup: LatLon.fromJson(json['pickup'] as Map<String, dynamic>),
      status: OrderStatusX.fromWire(json['status'] as String),
      statusHistory: (json['statusHistory'] as List<dynamic>? ?? const [])
          .map((e) => StatusHistoryEntry.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
      cancelReason: json['cancelReason'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'restaurantId': restaurantId,
    'courierId': courierId, // keep null if null (Mongo default null)
    'consumerId': consumerId,
    'items': items.map((e) => e.toJson()).toList(growable: false),
    'dropoff': dropoff.toJson(),
    'pickup': pickup.toJson(),
    'status': status.toWire(),
    'statusHistory': statusHistory
        .map((e) => e.toJson())
        .toList(growable: false),
    if (cancelReason != null) 'cancelReason': cancelReason,
    'isActive': isActive,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
  };

  Order copyWith({
    String? id,
    String? restaurantId,
    String? courierId,
    String? consumerId,
    List<OrderItem>? items,
    LatLon? dropoff,
    LatLon? pickup,
    OrderStatus? status,
    List<StatusHistoryEntry>? statusHistory,
    String? cancelReason,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Order(
    id: id ?? this.id,
    restaurantId: restaurantId ?? this.restaurantId,
    courierId: courierId ?? this.courierId,
    consumerId: consumerId ?? this.consumerId,
    items: items ?? this.items,
    dropoff: dropoff ?? this.dropoff,
    pickup: pickup ?? this.pickup,
    status: status ?? this.status,
    statusHistory: statusHistory ?? this.statusHistory,
    cancelReason: cancelReason ?? this.cancelReason,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
