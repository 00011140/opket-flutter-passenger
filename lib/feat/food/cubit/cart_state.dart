import 'package:opket/feat/food/models/cart_item.dart';
import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final String? restaurantId;
  final int? deliveryFee;
  final Map<String, CartItem> itemsById;
  final String? consumerNote;

  const CartState({
    required this.restaurantId,
    required this.itemsById,
    this.deliveryFee,
    this.consumerNote,
  });

  factory CartState.initial() =>
      const CartState(restaurantId: null, itemsById: {});

  List<CartItem> get items => itemsById.values.toList();

  int get totalItems => items.fold(0, (sum, e) => sum + e.quantity);
  int get subtotal => items.fold(0, (sum, e) => sum + e.lineTotal);

  bool get isEmpty => itemsById.isEmpty;

  CartState copyWith({
    String? restaurantId,
    Map<String, CartItem>? itemsById,
    int? deliveryFee,
    String? consumerNote,
  }) {
    return CartState(
      restaurantId: restaurantId ?? this.restaurantId,
      itemsById: itemsById ?? this.itemsById,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      consumerNote: consumerNote ?? this.consumerNote,
    );
  }

  Map<String, dynamic> toCreateOrderJson() {
    final json = <String, dynamic>{
      "restaurantId": restaurantId,
      "items": items.map((e) => e.toOrderJson()).toList(),
      "itemsSubtotal": subtotal,
      "deliveryFee": deliveryFee,
    };
    final note = consumerNote?.trim() ?? "";
    if (note.isNotEmpty) {
      json["consumerNote"] = note;
    }
    return json;
  }

  @override
  List<Object?> get props => [restaurantId, itemsById, deliveryFee, consumerNote];
}
