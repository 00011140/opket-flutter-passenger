import 'package:flutter/material.dart';

class TooltipAnimated extends StatelessWidget {
  final Widget child;
  final bool visible;

  const TooltipAnimated({
    super.key,
    required this.child,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        offset: visible ? Offset.zero : const Offset(0, 0.05),
        curve: Curves.easeOut,
        child: child,
      ),
    );
  }
}
