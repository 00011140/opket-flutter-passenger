import 'package:flutter/material.dart';
import 'package:opket/core/constants/app_icons.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 20.0,
        padding: EdgeInsets.all(0),
      ),
      onPressed:
          onPressed ??
          () {
            Navigator.pop(context);
          },
      icon: Icon(AppIcons.chevronLeft, size: 32),
    );
  }
}
