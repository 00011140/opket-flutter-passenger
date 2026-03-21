import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool enabled;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? color;
  final EdgeInsets padding;
  final double fontSize;
  final Widget? customText;

  const AppButton({
    super.key,
    required this.text,
    required this.isLoading,
    this.enabled = true,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFFFE500),
    this.padding = const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
    this.fontSize = 18,
    this.customText,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: padding,
      ),
      onPressed: isLoading || !enabled ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : customText ??
                Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: color ?? Colors.black,
                  ),
                ),
    );
  }
}
