import 'package:flutter/material.dart';
import 'package:opket/components/dashed_divider.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:opket/utils/extensions.dart';

class DeliveryMenuItems extends StatelessWidget {
  const DeliveryMenuItems({
    super.key,
    required this.items,
    required this.itemsSubtotal,
    required this.deliveryFee,
    required this.total,
  });
  final List<OrderItem> items;
  final int itemsSubtotal;
  final int deliveryFee;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...items.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: TextStyle(fontSize: 20)),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      "${(item.price * item.quantity).formatWithThousands()} UZS",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  "${item.quantity.toString()}x",
                  style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        DashedDivider(height: 1, dashSpace: 4, dashWidth: 10),
        SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("TAOM:", style: TextStyle(fontSize: 22)),
            _buildPrice(itemsSubtotal),
          ],
        ),
        SizedBox(height: AppSpacing.sm),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("YETKAZISH:", style: TextStyle(fontSize: 22)),
            _buildPrice(deliveryFee),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        DashedDivider(height: 1, dashSpace: 4, dashWidth: 10),
        SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("JAMI:", style: TextStyle(fontSize: 22)),
            _buildPrice(total),
          ],
        ),
      ],
    );
  }

  Widget _buildPrice(int price) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "${price.formatWithThousands()} ",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          TextSpan(text: "so'm", style: const TextStyle(fontSize: 22)),
        ],
      ),
    );
  }
}
