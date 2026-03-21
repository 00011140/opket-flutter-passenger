import 'menu_item_model.dart';

class CartItem {
  final MenuItemModel item;
  final int quantity;
  final String? note;

  const CartItem({required this.item, required this.quantity, this.note});

  CartItem copyWith({MenuItemModel? item, int? quantity, String? note}) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  int get lineTotal => item.price * quantity;

  Map<String, dynamic> toOrderJson() => {
    "menuItemId": item.id,
    "quantity": quantity,
    if (note != null && note!.trim().isNotEmpty) "note": note,
  };
}
