import 'package:flutter/material.dart';

class CustomMapPin extends StatelessWidget {
  const CustomMapPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(size: const Size(45, 50), painter: MapPinPainter()),
    );
  }
}

class MapPinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    /// 🟡 Yellow donut
    final yellowPaint = Paint()
      ..color = const Color(0xFFFFE711)
      ..style = PaintingStyle.fill;

    final outerRadius = size.width * 0.4;
    final innerRadius = outerRadius * 0.4;

    final donutCenter = Offset(centerX, outerRadius);

    // Outer circle
    canvas.drawCircle(donutCenter, outerRadius, yellowPaint);

    // Inner hole
    final holePaint = Paint()..color = Colors.grey.shade300;

    canvas.drawCircle(donutCenter, innerRadius, holePaint);

    /// ⚫ Black stem
    final stemPaint = Paint()..color = Colors.black87;

    final stemWidth = outerRadius * 0.20;
    final stemHeight = size.height - outerRadius * 2;

    final stemRect = Rect.fromCenter(
      center: Offset(centerX, outerRadius * 2 + stemHeight / 2),
      width: stemWidth,
      height: stemHeight,
    );

    final stemRRect = RRect.fromRectAndRadius(
      stemRect,
      Radius.circular(stemWidth),
    );

    canvas.drawRRect(stemRRect, stemPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
