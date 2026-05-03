import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/cart_state.dart';
import 'package:opket/feat/food/cubit/delivery_fee_cubit.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:shimmer/shimmer.dart';

class BasketSummary extends StatelessWidget {
  const BasketSummary({
    super.key,
    required this.toggle,
    required this.collapsed,
  });
  final VoidCallback toggle;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: toggle,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 12, 6, 12),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      "Batafsil",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      collapsed
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: const Color(0xFF6B7280),
                    ),
                  ],
                ),
              ),

              BlocBuilder<DeliveryFeeCubit, DeliveryFeeState>(
                builder: (context, state) {
                  if (state is DeliveryFeeLoading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.white,
                      child: DeliverFeeTotal(),
                    );
                  } else if (state is DeliveryFeeLoaded) {
                    return DeliverFeeTotal(deliveryfee: state.data);
                  } else {
                    return DeliverFeeTotal();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeliverFeeTotal extends StatelessWidget {
  const DeliverFeeTotal({super.key, this.deliveryfee = 0});
  final int deliveryfee;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: (state.subtotal + deliveryfee).formatWithThousands(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const TextSpan(
                text: " so'm",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
