import 'package:flutter/cupertino.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/feat/food/restaurants_page.dart';

class DashboardFoodButton extends StatefulWidget {
  const DashboardFoodButton({super.key});

  @override
  State<DashboardFoodButton> createState() => _DashboardFoodButtonState();
}

class _DashboardFoodButtonState extends State<DashboardFoodButton> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppIconButtonRectangle(
        text: "TAOM",
        customWidget: Image.asset("assets/burger.png", width: 40),
        onPressed: _openFoodPage,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
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
