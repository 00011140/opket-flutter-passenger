import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/models/cart_item.dart';
import 'package:opket/feat/food/models/menu_item_model.dart';

import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState.initial());

  /// If you want to enforce one restaurant per cart:
  /// - if restaurant differs, clear and start new cart (or throw)
  void addItem(MenuItemModel item, {int quantity = 1, String? note}) {
    if (quantity <= 0) return;

    // Enforce single restaurant
    final currentRestaurantId = state.restaurantId;
    if (currentRestaurantId != null &&
        currentRestaurantId != item.restaurantId) {
      // Option A: clear automatically
      // (Option B: emit an error state, or throw, or show dialog before clearing)
      emit(CartState(restaurantId: item.restaurantId, itemsById: {}));
    } else if (currentRestaurantId == null) {
      emit(state.copyWith(restaurantId: item.restaurantId));
    }

    final map = Map<String, CartItem>.from(state.itemsById);
    final existing = map[item.id];

    if (existing == null) {
      map[item.id] = CartItem(item: item, quantity: quantity, note: note);
    } else {
      map[item.id] = existing.copyWith(
        quantity: existing.quantity + quantity,
        note: note ?? existing.note,
      );
    }

    emit(state.copyWith(itemsById: map));
  }

  void setDeliveryFee(int deliveryFee) {
    emit(state.copyWith(deliveryFee: deliveryFee));
  }

  void removeItem(String menuItemId) {
    final map = Map<String, CartItem>.from(state.itemsById);
    map.remove(menuItemId);

    if (map.isEmpty) {
      emit(CartState.initial());
    } else {
      emit(state.copyWith(itemsById: map));
    }
  }

  void clear() => emit(CartState.initial());

  void increment(String menuItemId) {
    final existing = state.itemsById[menuItemId];
    if (existing == null) return;

    final map = Map<String, CartItem>.from(state.itemsById);
    map[menuItemId] = existing.copyWith(quantity: existing.quantity + 1);
    emit(state.copyWith(itemsById: map));
  }

  void decrement(String menuItemId) {
    final existing = state.itemsById[menuItemId];
    if (existing == null) return;

    final newQty = existing.quantity - 1;
    if (newQty <= 0) {
      removeItem(menuItemId);
      return;
    }

    final map = Map<String, CartItem>.from(state.itemsById);
    map[menuItemId] = existing.copyWith(quantity: newQty);
    emit(state.copyWith(itemsById: map));
  }

  void setQuantity(String menuItemId, int quantity) {
    final existing = state.itemsById[menuItemId];
    if (existing == null) return;

    if (quantity <= 0) {
      removeItem(menuItemId);
      return;
    }

    final map = Map<String, CartItem>.from(state.itemsById);
    map[menuItemId] = existing.copyWith(quantity: quantity);
    emit(state.copyWith(itemsById: map));
  }

  void setNote(String menuItemId, String? note) {
    final existing = state.itemsById[menuItemId];
    if (existing == null) return;

    final map = Map<String, CartItem>.from(state.itemsById);
    map[menuItemId] = existing.copyWith(note: note);
    emit(state.copyWith(itemsById: map));
  }

  int getQty(String menuItemId) {
    return state.itemsById[menuItemId]?.quantity ?? 0;
  }
}
