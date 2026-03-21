import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({super.key, this.horizontalMargin = 5.0});
  final double horizontalMargin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.maxFinite,
      height: 0.2,
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      color: Colors.grey,
    );
  }
}
