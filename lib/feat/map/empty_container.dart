import 'package:flutter/material.dart';
import 'package:opket/feat/food/widgets/menu_basket.dart';

class EmptyContainer extends StatefulWidget {
  const EmptyContainer({super.key});

  @override
  State<EmptyContainer> createState() => _EmptyContainerState();
}

class _EmptyContainerState extends State<EmptyContainer> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBasketSheet(context);
    });
    super.initState();
  }

  void _showBasketSheet(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
      elevation: 20.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      (_) => MenuBasket(onTap: () {}, buttonTitle: ""),
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
