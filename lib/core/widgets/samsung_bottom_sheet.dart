import 'package:flutter/material.dart';

class SamsungBottomSheet extends StatelessWidget {
  final Widget child;

  const SamsungBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 0, 12, bottomPadding + 12),
        child: Material(
          elevation: 20,
          shadowColor: const Color.fromARGB(126, 0, 0, 0),
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          child: child,
        ),
      ),
    );
  }
}
