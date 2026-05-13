import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/food/cubit/order_food_cubit.dart';

import 'detailed_cart_summary.dart';

class MenuBasket extends StatelessWidget {
  const MenuBasket({
    super.key,
    this.bottom,
    required this.onTap,
    required this.buttonTitle,
  });
  final double? bottom;
  final VoidCallback onTap;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    final bottomInset = bottom ?? MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CartView(),
          BlocBuilder<OrderFoodCubit, OrderFoodState>(
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
    );
  }
}
