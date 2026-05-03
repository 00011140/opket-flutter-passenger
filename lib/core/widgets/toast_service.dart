import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:opket/app/app.dart';

class ToastService {
  static OverlayEntry? _entry;
  static _TopToastState? _toastState;

  /// Persistent toast (with icon)
  static void showPersistent(String message) {
    if (_entry != null) return;

    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (_) => _TopToast(
        message: message,
        showIcon: true,
        autoHideDuration: null, // persistent
        onCreated: (state) {
          _toastState = state;
        },
      ),
    );

    overlay.insert(_entry!);
  }

  /// Auto-hide toast (NO icon) - hides after 4 seconds by default
  static void showAutoHide(
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    if (_entry != null) return;

    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (_) => _TopToast(
        message: message,
        showIcon: false,
        autoHideDuration: duration,
        onCreated: (state) {
          _toastState = state;
        },
      ),
    );

    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
    _toastState = null;
  }

  /// Call this to trigger shake
  static void shake() {
    _toastState?.shake();
  }
}

class _TopToast extends StatefulWidget {
  final String message;
  final void Function(_TopToastState) onCreated;

  /// null = persistent
  final Duration? autoHideDuration;

  /// If false -> no icon in UI
  final bool showIcon;

  const _TopToast({
    required this.message,
    required this.onCreated,
    required this.showIcon,
    this.autoHideDuration,
  });

  @override
  State<_TopToast> createState() => _TopToastState();
}

class _TopToastState extends State<_TopToast> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shakeController;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();

    // Slide + fade animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Smooth shake animation
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    widget.onCreated(this);

    // Auto-hide timer
    if (widget.autoHideDuration != null) {
      _autoHideTimer = Timer(widget.autoHideDuration!, () {
        ToastService.hide();
      });
    }
  }

  /// Call this to shake the toast
  void shake() {
    if (!_shakeController.isAnimating) {
      _shakeController
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: Listenable.merge([_slide, _fade, _shakeController]),
        builder: (context, child) {
          double offsetX = 0.0;
          if (_shakeController.isAnimating) {
            // sinusoidal shake for smooth back/forth motion
            offsetX = 8.0 * math.sin(_shakeController.value * 4 * math.pi);
          }

          return Transform.translate(
            offset: Offset(offsetX, _slide.value.dy * 50), // slide down by 50
            child: Opacity(
              opacity: _fade.value,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(20),
                shadowColor: const Color.fromARGB(89, 0, 0, 0),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      if (widget.showIcon) ...[
                        const Icon(Icons.wifi_off, size: 24, color: Colors.red),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }
}
