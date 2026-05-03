import 'package:flutter/material.dart';
import 'package:opket/core/widgets/dashed_divider.dart';
import 'package:opket/feat/food/widgets/basket_items.dart';
import 'package:opket/feat/food/widgets/basket_summary.dart';
import 'package:opket/feat/food/widgets/delivery_fee.dart';

class CartView extends StatefulWidget {
  final ValueChanged<int>? onTotalChanged;

  const CartView({super.key, this.onTotalChanged});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView>
    with SingleTickerProviderStateMixin {
  bool _collapsed = true;

  void _toggle() => setState(() => _collapsed = !_collapsed);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Collapsible area
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: _collapsed ? 0.0 : 1.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Items
                    BasketItems(),
                    DeliveryFee(),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (!_collapsed)
          const DashedDivider(
            height: 1.5,
            color: Color(0xFFE5E7EB),
            dashSpace: 8,
            dashWidth: 10,
          ),
        BasketSummary(toggle: _toggle, collapsed: _collapsed),
      ],
    );
  }
}
