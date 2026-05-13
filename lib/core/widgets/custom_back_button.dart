import 'package:flutter/material.dart';

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
      icon: Icon(Icons.chevron_left_rounded, size: 32),
    );
  }
}
