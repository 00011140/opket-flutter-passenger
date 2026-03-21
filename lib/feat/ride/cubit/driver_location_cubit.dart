import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:opket/models/driver_location.dart';
import 'package:opket/services/socket_service.dart';

part 'driver_location_state.dart';

class DriverLocationCubit extends Cubit<DriverLocationState> {
  final CurrentRideCubit currentRideCubit;

  late final StreamSubscription _driverLocationSub;

  DriverLocationCubit(this.currentRideCubit) : super(DriverLocationInitial()) {
    _driverLocationSub = SocketService.instance.onDriverLocation.listen(
      _handleDriverLocation,
    );
  }

  void _handleDriverLocation(dynamic data) {
    if (currentRideCubit.state.status != RideStatus.accepted) return;

    final incoming = DriverLocation.fromMap(data['location']);

    final prev = state is DriverLocationUpdate
        ? (state as DriverLocationUpdate).location
        : null;

    final merged = DriverLocation(
      lat: incoming.lat,
      lon: incoming.lon,
      bearing: incoming.bearing ?? prev?.bearing,
    );

    emit(DriverLocationUpdate(location: merged));
  }

  void reset() {
    emit(DriverLocationInitial());
  }

  @override
  Future<void> close() {
    _driverLocationSub.cancel();
    return super.close();
  }
}
