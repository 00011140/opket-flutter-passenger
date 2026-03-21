import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/cubit/premium_taxi_cubit.dart';
import 'package:opket/feat/dashboard/cubit/call_cubit.dart';
import 'package:opket/feat/ride/services/ride_persist_status.dart';
import 'package:opket/models/driver_location.dart';
import 'package:opket/models/ride_model.dart';
import 'package:opket/services/audio_service.dart';
import 'package:opket/services/socket_service.dart';

import 'current_ride_state.dart';

class CurrentRideCubit extends Cubit<CurrentRideState> {
  late final StreamSubscription _sub;
  late final StreamSubscription _rideStartedSubscription;
  late final StreamSubscription _rideNoDriversSub;
  late final StreamSubscription _driverArrivedSub;
  final CallCubit callCubit;
  final PremiumTaxiCubit premiumTaxiCubit;
  final RidePersistService ridePersistService;

  CurrentRideCubit({
    required this.callCubit,
    required this.premiumTaxiCubit,
    required this.ridePersistService,
  }) : super(CurrentRideState()) {
    _sub = SocketService.instance.onRideAccepted.listen(_handleRideAccepted);
    _rideNoDriversSub = SocketService.instance.onNoDrivers.listen(
      _handleNoDrivers,
    );
    _rideStartedSubscription = SocketService.instance.onRideStarted.listen(
      _handleRideStarted,
    );
    _driverArrivedSub = SocketService.instance.driverArrived.listen(
      _handleDriverArrived,
    );
  }

  void _handleDriverArrived(_) {
    AudioService().playSound('driver_arrived.m4a');
  }

  // Handle the ride started event
  void _handleRideStarted(_) {
    reset();
  }

  Future<void> restoreRide() async {
    final savedState = await ridePersistService.loadState();
    if (savedState != null) {
      emit(savedState);
    }
  }

  void _handleRideAccepted(dynamic data) {
    try {
      premiumTaxiCubit.reset();
      callCubit.setCallingPageStatus(false);
      AudioService().stopSound();
      AudioService().playSound('ride_accepted.mp3');

      print("🚕🚕: ${data['location']} ");

      final Map<String, dynamic> driverRaw = data['driver'];
      final location = DriverLocation.fromMap(data['location']);

      final driver = DriverModel(
        driverName: driverRaw['name'],
        phone: driverRaw['phone'],
        carModel: driverRaw['carModel'],
        carColor: driverRaw['carColor'],
        carNumber: driverRaw['carNumber'],
        regionCode: driverRaw['regionCode'],
      );

      emit(
        state.copyWith(
          driver: driver,
          status: RideStatus.accepted,
          location: location,
        ),
      );
      ridePersistService.saveState(state.toMap());
    } catch (e) {
      print("🚕🚕 ERROR Ride accpeted $e");
    }
  }

  void _handleDriverLocation(dynamic data) {
    final location = DriverLocation.fromMap(data['location']);
    emit(state.copyWith(location: location));
  }

  void _handleNoDrivers(dynamic data) {
    AudioService().playSound('re_request_ride.m4a');
  }

  void setData(String rideId) {
    emit(state.copyWith(rideId: rideId, status: RideStatus.pending));
    ridePersistService.saveState(state.toMap());
  }

  void reset() {
    emit(CurrentRideState());
    ridePersistService.clear();
  }

  @override
  Future<void> close() {
    _sub.cancel();
    _rideStartedSubscription.cancel();
    _rideNoDriversSub.cancel();
    return super.close();
  }
}
