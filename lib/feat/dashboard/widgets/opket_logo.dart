import 'package:flutter/material.dart';
import 'package:opket/core/theme/spacing.dart';

class OpketLogo extends StatelessWidget {
  final Color textColor;
  final double radius;
  final bool isLight;

  const OpketLogo({
    super.key,
    this.textColor = Colors.black,
    this.radius = 25,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image.asset("assets/opket_logo.png", width: 40),
        SizedBox(width: AppSpacing.sm),
        Text(
          "OPKET",
          style: TextStyle(
            fontFamily: 'WorkSans',
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: isLight ? Colors.white : null,
          ),
        ),
      ],
    );
  }
}
