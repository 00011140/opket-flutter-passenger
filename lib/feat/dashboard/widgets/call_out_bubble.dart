import 'package:flutter/material.dart';

import 'dart:math' as math;

class CalloutBubble extends StatefulWidget {
  final bool showLocationHints;
  final bool isUserLocation;

  const CalloutBubble({
    super.key,
    required this.showLocationHints,
    required this.isUserLocation,
  });

  @override
  State<CalloutBubble> createState() => _CalloutBubbleState();
}

class _CalloutBubbleState extends State<CalloutBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Shake immediately if it starts visible
    if (widget.showLocationHints) {
      _shakeController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CalloutBubble oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger shake ONLY when false -> true
    if (!oldWidget.showLocationHints && widget.showLocationHints) {
      _shakeController
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.center,
        child: AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            double offsetX = 0.0;

            if (_shakeController.isAnimating) {
              offsetX = 8.0 * math.sin(_shakeController.value * 4 * math.pi);
            }

            return Transform.translate(
              offset: Offset(offsetX, 0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: widget.showLocationHints ? 1 : 0,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.867),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: !widget.isUserLocation
                        ? Text.rich(
                            TextSpan(
                              text: "Siz turgan joylashuv emas",
                              style: const TextStyle(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: " !",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(
                            "Bu siz turgan joylashuv",
                            style: const TextStyle(fontSize: 14),
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
}
