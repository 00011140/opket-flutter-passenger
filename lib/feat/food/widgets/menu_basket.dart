import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
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
    this.enableRestaurantNote = false,
  });
  final BuildContext ctx;
  final double? bottom;
  final VoidCallback onTap;
  final String buttonTitle;
  final bool enableRestaurantNote;

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
            if (enableRestaurantNote) const _RestaurantNoteField(),
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

class _RestaurantNoteField extends StatefulWidget {
  const _RestaurantNoteField();

  @override
  State<_RestaurantNoteField> createState() => _RestaurantNoteFieldState();
}

class _RestaurantNoteFieldState extends State<_RestaurantNoteField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: context.read<CartCubit>().state.consumerNote ?? "",
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: TextField(
        controller: _ctrl,
        maxLines: 2,
        minLines: 1,
        maxLength: 300,
        textInputAction: TextInputAction.done,
        onChanged: (v) => context.read<CartCubit>().setConsumerNote(v),
        style: const TextStyle(fontSize: 13.5),
        decoration: InputDecoration(
          isDense: true,
          hintText: "Restoranga izoh (ixtiyoriy)",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13.5),
          counterText: "",
          filled: true,
          fillColor: const Color(0xFFF6F6F6),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black87, width: 1),
          ),
        ),
      ),
    );
  }
}
