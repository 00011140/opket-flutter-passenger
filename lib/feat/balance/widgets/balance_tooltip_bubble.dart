import 'package:flutter/material.dart';

class BalanceTooltipBubble extends StatelessWidget {
  final bool showAbove;

  const BalanceTooltipBubble({super.key, required this.showAbove});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!showAbove) _ArrowDown(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12),
            ],
          ),
          child: const Text(
            "Tap to manage your balance",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        if (showAbove) _ArrowUp(),
      ],
    );
  }
}

class _ArrowUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 10),
      painter: _ArrowPainter(up: true),
    );
  }
}

class _ArrowDown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 10),
      painter: _ArrowPainter(up: false),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final bool up;

  _ArrowPainter({required this.up});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;

    final path = Path();
    if (up) {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
