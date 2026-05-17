import 'package:flutter/material.dart';
import 'package:opket/core/constants/app_icons_v3.dart';
import 'package:opket/core/widgets/app_icon_button_circle.dart';

class RecenterButton extends StatelessWidget {
  final VoidCallback onTap;

  const RecenterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppIconButtonCircle(
      icon: AppIconsV3.navigation,
      onPressed: onTap,
    );
  }
}
