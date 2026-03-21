import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/cart_state.dart';
import 'package:opket/feat/food/cubit/current_restaurant_cubit.dart';
import 'package:opket/feat/food/cubit/restaurant_categories_cubit.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:opket/feat/food/widgets/clear_basket_confirmation_dialog.dart';
import 'package:opket/feat/food/widgets/restaurant_menu.dart';
import 'package:opket/feat/food/widgets/restaurant_menu_appbar.dart';

class RestaurantDetailPage extends StatefulWidget {
  const RestaurantDetailPage({super.key, required this.restaurant});
  final RestaurantModel restaurant;

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CurrentRestaurantCubit>().setData(widget.restaurant);
    context.read<RestaurantCategoriesCubit>().loadData(widget.restaurant.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return PopScope(
          canPop: state.items.isEmpty,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _clearBasketConfirmation();
          },

          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarContrastEnforced: true,
            ),
            child: Scaffold(
              extendBody: true,
              body: SafeArea(
                bottom: false,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      RestaurantMenuAppbar(name: widget.restaurant.name),
                      // Categories + content are both based on the same Cubit state:
                      RestaurantMenu(restaurant: widget.restaurant),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _clearBasketConfirmation() {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return ClearBasketConfirmationDialog();
      },
    );
  }
}
