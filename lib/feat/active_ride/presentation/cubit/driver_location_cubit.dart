import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/models/driver_location.dart';
import 'package:opket/core/services/socket_service.dart';
import 'package:opket/feat/active_ride/index.dart';

part 'driver_location_state.dart';

class DriverLocationCubit extends Cubit<DriverLocationState> {
  final ActiveRideCubit currentRideCubit;

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
      latitude: incoming.latitude,
      longitude: incoming.longitude,
      heading: incoming.heading ?? prev?.heading,
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
