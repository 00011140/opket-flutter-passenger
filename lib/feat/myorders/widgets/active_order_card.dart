import 'package:flutter/material.dart';
import 'package:opket/components/app_card.dart';
import 'package:opket/components/app_container.dart';
import 'package:opket/components/dashed_divider.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:opket/feat/myorders/widgets/active_order_label.dart';
import 'package:opket/feat/myorders/widgets/delivery_menu_items.dart';
import 'package:opket/routes/route_names.dart';

class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({
    super.key,
    required this.order,
    this.isSummary = false,
  });
  final FoodOrder order;
  final bool isSummary;

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      top: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: AppCard(
          onTap: () {
            if (!isSummary) return;
            Navigator.pushNamed(context, RouteNames.myordersActive);
          },
          child: Column(
            children: [_buildSummary(), if (!isSummary) _buildDetails()],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "#${order.orderNumber}",
                  style: TextStyle(
                    color: order.status.color,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Text(order.restaurantId.name, style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              "${order.items.length.toString()} ta mahsulot",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
        ActiveOrderLabel(status: order.status),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      children: [
        SizedBox(height: AppSpacing.md),
        DashedDivider(height: 1, dashSpace: 4, dashWidth: 10),
        SizedBox(height: AppSpacing.md),
        DeliveryMenuItems(
          items: order.items,
          itemsSubtotal: order.pricing.itemsSubtotal,
          deliveryFee: order.pricing.deliveryFee,
          total: order.pricing.total,
        ),
      ],
    );
  }
}
