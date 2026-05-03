import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/cart_state.dart';
import 'package:opket/feat/food/widgets/menu_item_price.dart';

class BasketSummaryBar extends StatelessWidget {
  const BasketSummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartCubit, CartState, _BasketSummaryVm>(
      selector: (state) => _BasketSummaryVm(
        totalItems: state.totalItems,
        subtotal: state.subtotal,
        isEmpty: state.isEmpty,
      ),
      builder: (context, vm) {
        if (vm.isEmpty) return const SizedBox.shrink();

        return Material(
          color: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [MenuItemPrice(price: vm.subtotal)]),
                const SizedBox(width: 12),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                  label: const Text(
                    "Batafsil",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BasketSummaryVm {
  final int totalItems;
  final int subtotal;
  final bool isEmpty;

  const _BasketSummaryVm({
    required this.totalItems,
    required this.subtotal,
    required this.isEmpty,
  });
}
