import 'package:flutter/material.dart';

class RequestRideSheetController {
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  final ValueNotifier<double> progress = ValueNotifier(0.0);

  static const double minSize = 0.22;
  static const double maxSize = 1.0;

  bool get isExpanded => progress.value > 0.95;

  RequestRideSheetController() {
    sheetController.addListener(_onSheetChanged);
  }

  void _onSheetChanged() {
    final t = ((sheetController.size - minSize) / (maxSize - minSize)).clamp(
      0.0,
      1.0,
    );

    progress.value = t;
  }

  Future<void> expand() {
    return sheetController.animateTo(
      maxSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> collapse() {
    return sheetController.animateTo(
      minSize,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  void dispose() {
    sheetController.dispose();
    progress.dispose();
  }
}
