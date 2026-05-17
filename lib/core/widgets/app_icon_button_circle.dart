import 'package:flutter/material.dart';

class AppIconButtonCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  final Color splashColor;
  final List<BoxShadow>? boxShadow;

  const AppIconButtonCircle({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 52,
    this.iconSize = 20,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.black87,
    this.splashColor = const Color(0x1A000000),
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
      ),
      child: Material(
        shape: const CircleBorder(),
        color: backgroundColor,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          splashColor: splashColor,
          highlightColor: splashColor,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
        ),
      ),
    );
  }
}
