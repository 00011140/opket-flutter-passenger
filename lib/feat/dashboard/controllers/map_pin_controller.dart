import 'dart:ui';

class MapPinController {
  VoidCallback? _onLift;
  VoidCallback? _onDrop;

  /// Called by the widget to register its handlers
  void attach({required VoidCallback onLift, required VoidCallback onDrop}) {
    _onLift = onLift;
    _onDrop = onDrop;
  }

  void detach() {
    _onLift = null;
    _onDrop = null;
  }

  /// Called by parent (Dashboard)
  void lift() => _onLift?.call();
  void drop() => _onDrop?.call();
}
