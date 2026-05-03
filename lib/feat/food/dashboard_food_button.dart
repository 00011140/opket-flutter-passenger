import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/feat/food/restaurants_page.dart';

class DashboardFoodButton extends StatefulWidget {
  const DashboardFoodButton({super.key});

  @override
  State<DashboardFoodButton> createState() => _DashboardFoodButtonState();
}

class _DashboardFoodButtonState extends State<DashboardFoodButton> {
  @override
  Widget build(BuildContext context) {
    return AppIconButtonRectangle(
      width: AppButtonWidth.wrap,
      text: "TAOM",
      customWidget: Padding(
        padding: EdgeInsetsGeometry.only(right: AppSpacing.sm),
        child: Image.asset("assets/burger.png", width: 40),
      ),
      onPressed: _openFoodPage,
      textColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }

  void _openFoodPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => const RestaurantsPage(),
        fullscreenDialog: true,
      ),
    );
  }
}
