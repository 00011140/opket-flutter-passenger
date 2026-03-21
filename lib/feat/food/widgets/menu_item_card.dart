import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/cart_state.dart';
import 'package:opket/feat/food/models/menu_item_model.dart';
import 'package:opket/feat/food/widgets/menu_basket.dart';
import 'package:opket/feat/food/widgets/menu_item_price.dart';
import 'package:opket/feat/food/widgets/product_quantity_control.dart';
import 'package:opket/routes/route_names.dart';
import 'package:opket/services/location_service.dart';

class ProductCard extends StatelessWidget {
  final MenuItemModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartCubit, CartState, int>(
      selector: (state) => state.itemsById[product.id]?.quantity ?? 0,
      builder: (context, qty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 247, 248, 249),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color.fromARGB(255, 247, 248, 249),
                            alignment: Alignment.center,
                            child: const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color.fromARGB(255, 247, 248, 249),
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ProductQuantityControl(
                    qty: qty,
                    onMinus: () => onMinues(context),
                    onPlus: () => onPlus(context, qty),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            MenuItemPrice(price: product.price),
            const SizedBox(height: 4),
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, color: Color(0xFF111827)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              "-",
              style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
            ),
          ],
        );
      },
    );
  }

  void onMinues(BuildContext context) {
    context.read<CartCubit>().decrement(product.id);
  }

  void onPlus(BuildContext context, int qty) async {
    final items = context.read<CartCubit>().state.items;
    if (items.isEmpty) _showBasketSheet(context);

    if (qty == 0) {
      context.read<CartCubit>().addItem(product, quantity: 1);
    } else {
      context.read<CartCubit>().increment(product.id);
    }
  }

  void _showBasketSheet(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
      elevation: 20.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        // borderRadius: BorderRadius.circular(20),
      ),
      (_) => MenuBasket(
        ctx: context,
        buttonTitle: "Buyurtma qilish",
        onTap: () {
          Navigator.pushNamed(context, RouteNames.orderFoodMap);
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
