import 'dart:async';

import 'package:opket/core/env.dart';
import 'package:opket/feat/active_ride/index.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Singleton data source that manages driver socket connection.
class SocketService {
  // 🔒 Private constructor
  SocketService._internal();

  // 🌍 Global instance
  static final SocketService instance = SocketService._internal();

  IO.Socket? _socket;

  /// Check if socket is connected
  bool get isConnected => _socket != null && _socket!.connected;
  bool get isInitialized => _socket != null;

  final _balanceDeductionRequestController =
      StreamController<dynamic>.broadcast();
  final _balanceTopUpController = StreamController<dynamic>.broadcast();
  final _noPremiumDriversController = StreamController<dynamic>.broadcast();
  final _addLuggageController = StreamController<dynamic>.broadcast();
  final _routeUpdateController = StreamController<dynamic>.broadcast();
  final _rideAcceptedController = StreamController<dynamic>.broadcast();
  final _rideCancelledController = StreamController<dynamic>.broadcast();
  final _rideNoDriversController = StreamController<dynamic>.broadcast();
  final _rideStartedController = StreamController<dynamic>.broadcast();
  final _rideCompletedController = StreamController<dynamic>.broadcast();
  final _driverArrivedController = StreamController<dynamic>.broadcast();
  final _driverLocationCtrl = StreamController<dynamic>.broadcast();
  final _featureFlagsCtlr = StreamController<dynamic>.broadcast();
  final _candidateDriversCtlr = StreamController<dynamic>.broadcast();
  final _rideProgressCtrl = StreamController<dynamic>.broadcast();

  Stream<dynamic> get onRouteUpdated => _routeUpdateController.stream;
  Stream<dynamic> get onRideProgress => _rideProgressCtrl.stream;
  Stream<dynamic> get onAddLuggage => _addLuggageController.stream;
  Stream<dynamic> get onRideAccepted => _rideAcceptedController.stream;
  Stream<dynamic> get onDriverLocation => _driverLocationCtrl.stream;
  Stream<dynamic> get onRideCancelled => _rideCancelledController.stream;
  Stream<dynamic> get onNoDrivers => _rideNoDriversController.stream;
  Stream<dynamic> get onCandidateDrivers => _candidateDriversCtlr.stream;
  Stream<dynamic> get onBalanceDeductionRequest =>
      _balanceDeductionRequestController.stream;
  Stream<dynamic> get onRideStarted => _rideStartedController.stream;
  Stream<dynamic> get onRideCompleted => _rideCompletedController.stream;
  Stream<dynamic> get driverArrived => _driverArrivedController.stream;
  Stream<dynamic> get onBalanceTopUp => _balanceTopUpController.stream;
  Stream<dynamic> get onNoPremiumDrivers => _noPremiumDriversController.stream;
  Stream<dynamic> get onFeatureFlags => _featureFlagsCtlr.stream;

  /// Initialize and connect socket with driver JWT token
  void connect(String token) {
    if (isInitialized) {
      print('⚠️ Socket already initialized — skipping reinit');
      return;
    }

    print("⚠️⚠️⚠️⚠️ SOKCET");

    _socket = IO.io(
      Env.baseUrl.replaceAll("/api", ''), // 🔗 your backend socket endpoint
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/socket.io')
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setAuth({'token': token}) // ✅ send phone for backend auth
          .build(),
    );

    _registerCoreEvents();
    _registerPassengerEvents();
  }

  /// Internal: register basic connection lifecycle events
  void _registerCoreEvents() {
    _socket?.onConnect((_) async {
      print('✅ Passenger socket connected');
    });

    _socket?.onDisconnect((_) {
      print('❌ Passenger socket disconnected');
    });

    _socket?.onReconnectAttempt((_) {
      print('♻️ Attempting socket reconnection...');
    });

    _socket?.onError((data) {
      print('⚠️ Socket error: $data');
    });
  }

  void _registerPassengerEvents() {
    _socket?.on('driver:location', (data) {
      _driverLocationCtrl.add(data);

      _socket?.emit('driver_location_update_ack', {
        'eventId': 'driver_location_update',
      });
    });

    _socket?.on('candidate_drivers', (data) {
      print("onCandidateDrivers:");
      print(data);
      _candidateDriversCtlr.add(data);
    });

    _socket?.on('route_update', (data) {
      _routeUpdateController.add(data);
    });

    _socket?.on('ride_no_drivers', (data) {
      _rideNoDriversController.add(data);

      _socket?.emit('ride_no_drivers_ack', {'eventId': 'ride_no_drivers'});
    });

    _socket?.on('ride_progress', (data) {
      _rideProgressCtrl.add(data);
    });

    _socket?.on('ride_accepted', (data) {
      _rideAcceptedController.add(data);

      _socket?.emit('ride_accepted_ack', {'eventId': 'ride_accepted'});
    });

    _socket?.on('add_luggage', (data) {
      _addLuggageController.add(data);

      _socket?.emit('add_luggage_ack', {'eventId': 'add_luggage'});
    });

    _socket?.on('ride_started', (data) {
      _rideStartedController.add(data);

      _socket?.emit('ride_started_ack', {'eventId': 'ride_started'});
    });

    _socket?.on('ride_completed', (data) {
      _rideCompletedController.add(data);

      _socket?.emit('ride_completed_ack', {'eventId': 'ride_completed'});
    });

    _socket?.on('driver_arrived', (data) {
      _driverArrivedController.add(data);

      _socket?.emit('driver_arrived_ack', {'eventId': 'driver_arrived'});
    });

    _socket?.on('ride_cancelled_by_driver', (data) {
      _rideCancelledController.add(data);
    });

    _socket?.on('balance_deduction_request', (data) {
      _balanceDeductionRequestController.add(data);

      _socket?.emit('balance_deduction_request_ack', {
        'eventId': 'balance_deduction_request',
      });
    });

    _socket?.on('balance_top_up', (data) {
      _balanceTopUpController.add(data);

      _socket?.emit('balance_top_up_ack', {'eventId': 'balance_top_up'});
    });

    _socket?.on('no_premium_drivers', (data) {
      _noPremiumDriversController.add(data);
      // _socket?.emit('balance_top_up_ack', {'eventId': 'balance_top_up'});
    });

    _socket?.on('feature_flags', (data) {
      print("💁💁💁 object");
      _featureFlagsCtlr.add(data);
    });
  }

  void declineRideChange(String driverId) {
    _emitSafe('ride_change_declined', {'driverId': driverId});
  }

  void confirmLuggage(String driverId) {
    _emitSafe('luggage_confirmed', {'driverId': driverId});
  }

  void hasPremiumCars() {
    _emitSafe('premium_taxi', {});
  }

  void declineLuggage(String driverId) {
    _emitSafe('luggage_declined', {'driverId': driverId});
  }

  /// Listen to any backend event
  void on(String event, void Function(dynamic data) callback) {
    if (!isInitialized) {
      print('⚠️ Socket not initialized yet');
      return;
    }
    print('🎲🎲🎲 $event');
    _socket?.on(event, callback);
  }

  /// Stop listening to a specific event
  void off(String event) {
    if (!isInitialized) return;
    _socket?.off(event);
  }

  /// Disconnect socket
  void disconnect() {
    if (!isInitialized) return;
    _socket?.disconnect();
    _socket = null;
  }

  /// Safely emit only when connected
  void _emitSafe(String event, dynamic data) {
    if (!isInitialized) {
      print('⚠️ Socket not initialized — cannot emit $event');
      return;
    }

    if (!isConnected) {
      print('⚠️ Socket not connected — buffering or skipping $event');
      return;
    }

    _socket?.emit(event, data);
    print('📤 Emitted $event => $data');
  }
}
