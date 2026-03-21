import 'package:flutter/material.dart';

class ProductQuantityControl extends StatelessWidget {
  const ProductQuantityControl({
    super.key,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final bool expanded = qty > 0;

    const double collapsedSize = 50;
    const double expandedHeight = 50;
    const double expandedWidth = 150;

    return Positioned(
      right: 14,
      bottom: 14,
      child: AnimatedContainer(
        clipBehavior: Clip.hardEdge,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        width: expanded ? expandedWidth : collapsedSize,
        height: expanded ? expandedHeight : collapsedSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            expanded ? 999 : collapsedSize / 2,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 18,
              offset: Offset(0, 10),
              color: Color(0x22000000),
            ),
          ],
        ),
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, anim) {
              return FadeTransition(
                opacity: anim,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.98, end: 1.0).animate(anim),
                  child: child,
                ),
              );
            },
            child: expanded
                ? _ExpandedControls(
                    key: const ValueKey('expanded'),
                    qty: qty,
                    onMinus: onMinus,
                    onPlus: onPlus,
                  )
                : _CollapsedPlus(
                    key: const ValueKey('collapsed'),
                    onTap: onPlus, // tapping + adds 1
                  ),
          ),
        ),
      ),
    );
  }
}

class _CollapsedPlus extends StatelessWidget {
  const _CollapsedPlus({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: const Center(
        child: Icon(Icons.add, size: 24, color: Colors.black87),
      ),
    );
  }
}

class _ExpandedControls extends StatelessWidget {
  const _ExpandedControls({
    super.key,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // const SizedBox(width: 10),
        _CircleIconButton(icon: Icons.remove, onTap: onMinus),
        const SizedBox(width: 10),
        Expanded(
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              transitionBuilder: (child, anim) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Text(
                '$qty',
                key: ValueKey(qty),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        _CircleIconButton(icon: Icons.add, onTap: onPlus),
        const SizedBox(width: 10),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,

      radius: 26,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(child: Icon(icon, size: 24, color: Colors.black87)),
      ),
    );
  }
}
