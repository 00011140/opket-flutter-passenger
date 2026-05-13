import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/cart_state.dart';
import 'package:opket/feat/food/cubit/current_restaurant_cubit.dart';
import 'package:opket/feat/food/cubit/restaurant_categories_cubit.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:opket/app/router/route_names.dart';
import 'package:opket/feat/food/cubit/order_food_cubit.dart';
import 'package:opket/feat/food/widgets/clear_basket_confirmation_dialog.dart';
import 'package:opket/feat/food/widgets/menu_basket.dart';
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
    context.read<OrderFoodCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!context.read<CartCubit>().state.isEmpty) {
          _clearBasketConfirmation();
        }
      },
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
              systemNavigationBarContrastEnforced: true,
            ),
            child: Scaffold(
              body: SafeArea(
                bottom: false,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
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
                            RestaurantMenu(restaurant: widget.restaurant),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) =>
                            SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                              child: child,
                            ),
                        child: state.items.isNotEmpty
                            ? MenuBasket(
                                key: const ValueKey('basket'),
                                buttonTitle: "Buyurtma qilish",
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  RouteNames.orderFoodMap,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
