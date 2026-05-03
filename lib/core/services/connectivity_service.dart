import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  bool _currentStatus = true; // cached value

  Stream<bool> get connectionStream => _connectionController.stream;

  /// Call once at app startup
  Future<void> initialize() async {
    final result = await _connectivity.checkConnectivity();
    _currentStatus = _hasConnection(result);
    _connectionController.add(_currentStatus);

    _connectivity.onConnectivityChanged.listen((result) {
      _currentStatus = _hasConnection(result);
      _connectionController.add(_currentStatus);
    });
  }

  /// 🔍 Get current internet status
  bool get hasInternet => _currentStatus;

  bool _hasConnection(List<ConnectivityResult> result) {
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);
  }

  void dispose() {
    _connectionController.close();
  }
}
