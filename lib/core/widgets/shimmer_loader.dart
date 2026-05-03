import 'package:flutter/material.dart';
import 'dart:math' as math;

class ShimmerLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final Widget? child;

  const ShimmerLoader({
    Key? key,
    this.width,
    this.height,
    this.child,
    this.borderRadius = 8,
    this.baseColor = Colors.white,
    this.highlightColor = const Color.fromARGB(255, 234, 234, 234),
  }) : super(key: key);

  @override
  _ShimmerLoaderState createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          painter: _ShimmerPainter(
            progress: _controller.value,
            baseColor: widget.baseColor,
            highlightColor: widget.highlightColor,
            borderRadius: widget.borderRadius,
          ),
          child: Opacity(
            opacity: 0,
            child:
                widget.child ??
                SizedBox(width: widget.width, height: widget.height),
          ),
        );
      },
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final double progress;
  final Color baseColor;
  final Color highlightColor;
  final double borderRadius;

  _ShimmerPainter({
    required this.progress,
    required this.baseColor,
    required this.highlightColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Base colored rectangle
    final baseRect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(borderRadius),
    );

    paint.shader =
        LinearGradient(
          colors: [baseColor, highlightColor, baseColor],
          stops: const [0.25, 0.5, 0.75],
          begin: Alignment(-1 - 1, 0),
          end: Alignment(1 + 1, 0),
          transform: GradientRotation(0),
        ).createShader(
          Rect.fromLTWH(
            size.width * progress * 2 - size.width,
            0,
            size.width * 2,
            size.height,
          ),
        );

    canvas.drawRRect(baseRect, paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
