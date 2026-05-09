import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/food/cubit/order_food_cubit.dart';
import 'package:opket/feat/food/widgets/order_food_success.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:opket/feat/myorders/services/order_local_storage.dart';
import 'package:opket/app/router/route_names.dart';

import 'detailed_cart_summary.dart';

class MenuBasket extends StatelessWidget {
  const MenuBasket({
    super.key,
    required this.ctx,
    this.bottom,
    required this.onTap,
    required this.buttonTitle,
  });
  final BuildContext ctx;
  final double? bottom;
  final VoidCallback onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    final viewPaddingBottom = MediaQuery.of(ctx).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom ?? viewPaddingBottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CartView(),
            BlocConsumer<OrderFoodCubit, OrderFoodState>(
              listener: (context, state) {
                if (state is OrderFoodSuccess) {
                  createOrder(state.order);

                  // Navigator.pop(context);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    RouteNames.dashboard,
                    (route) => false, // removes *everything* below
                    // arguments: DashboardArgs(activeFoodOrderId: orderId),
                  );
                  Navigator.of(context).pushNamed(RouteNames.myordersActive);
                  _showOrderFoodSuccessDialog(context);
                } else if (state is OrderFoodError) {
                  print("🐥🐥");
                  print(state.message);
                }
              },
              builder: (context, state) {
                return AppIconButtonRectangle(
                  text: buttonTitle,
                  isLoading: state is OrderFoodLoading,
                  onPressed: onTap,
                  backgroundColor: const Color(0xFFFFE711),
                  textColor: Colors.black,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createOrder(FoodOrder order) async {
    await OrderLocalStorage.saveOrder(order);
  }

  void _showOrderFoodSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return OrderFoodSuccessDialog();
      },
    );
  }
}
