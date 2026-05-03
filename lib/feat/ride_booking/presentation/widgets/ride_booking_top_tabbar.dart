import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/widgets/app_tabbar.dart';
import 'package:opket/feat/ride_booking/presentation/index.dart';

class RideBookingTopTabbar extends StatefulWidget {
  const RideBookingTopTabbar({super.key});

  @override
  State<RideBookingTopTabbar> createState() => _RideBookingTopTabbarState();
}

class _RideBookingTopTabbarState extends State<RideBookingTopTabbar>
    with TickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(200),
        boxShadow: const [BoxShadow(blurRadius: 15, color: Colors.black12)],
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          FoodLogo(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm_md),
              child: Container(color: Colors.grey.shade300, width: 1.5),
            ),
          ),
          DeliveryLogo(),
        ],
      ),
    );
    return AppTabBar(
      controller: _controller,
      tabs: [
        Tab(child: FoodLogo()),
        // Tab(child: AppbarLogo()),
        Tab(child: DeliveryLogo()),
      ],
    );
  }
}
