import 'package:flutter/material.dart';
import 'package:opket/core/constants/app_icons.dart';
import 'package:opket/core/constants/app_icons_v3.dart';

class RecenterButton extends StatelessWidget {
  final VoidCallback onTap;

  const RecenterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Icon(AppIconsV3.navigation, color: Colors.black87, size: 20),
        ),
      ),
    );
  }
}
