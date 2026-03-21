import 'package:flutter/material.dart';
import 'package:opket/utils/extensions.dart';

class MenuItemPrice extends StatelessWidget {
  const MenuItemPrice({super.key, required this.price});
  final int price;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: price.formatUzbekSoumFromCents(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          const TextSpan(
            text: " so'm",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Color(0xFF6B7280), // lighter / secondary color
            ),
          ),
        ],
      ),
    );
  }
}
