import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/toast_service.dart';
import 'package:opket/cubit/cool_down_cubit.dart';
import 'package:opket/cubit/premium_taxi_cubit.dart';
import 'package:opket/feat/dashboard/cubit/call_cubit.dart';
import 'package:opket/feat/dashboard/cubit/selected_location_cubit.dart';
import 'package:opket/feat/fare_by_options/fare_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/services/audio_service.dart';
import 'package:opket/services/request_ride_service.dart';
import 'package:opket/services/socket_service.dart';

part 'ride_state.dart';

class RideCubit extends Cubit<RideState> {
  SelectedLocationCubit selectedLocationCubit;
  CallCubit callCubit;
  PremiumTaxiCubit premiumTaxiCubit;
  FareCubit fareCubit;
  CurrentRideCubit currentRideCubit;
  CoolDownCubit coolDownCubit;
  bool isEndCallInitiated = false;
  late final StreamSubscription _sub;
  final socket = SocketService.instance;

  RideCubit({
    required this.selectedLocationCubit,
    required this.callCubit,
    required this.fareCubit,
    required this.premiumTaxiCubit,
    required this.currentRideCubit,
    required this.coolDownCubit,
  }) : super(RideInitial()) {
    _sub = SocketService.instance.onRideCancelled.listen(_handleRideCancelled);
  }

  void _handleRideCancelled(dynamic data) {
    reset();
    currentRideCubit.reset();
    coolDownCubit.inactive();
    premiumTaxiCubit.reset();
    ToastService.showAutoHide("Haydovchi buyurtmani bekor qildi");
  }

  void requestRide() async {
    final enabledServices = fareCubit.state.data?.fare.enabledServices ?? [];
    final selectedLocaton = selectedLocationCubit.state;
    if (selectedLocaton == null) return;

    emit(RideRequestLoading());
    try {
      final rideId = await RequestRideService().requestRide(
        selectedLocaton,
        premiumTaxiCubit.state.premium,
        enabledServices,
      );
      await AudioService().stopSound();
      if (rideId != null) {
        currentRideCubit.setData(rideId);
        emit(RideRequestSuccess(rideId: rideId));
      } else {
        emit(RideRequestError(message: "Taksi chaqrishida xatolik yuz berdi"));
      }
    } catch (e) {
      emit(RideRequestError(message: "Taksi chaqrishida xatolyik yuz berdi"));
    }
  }

  void endCall() {
    if (isEndCallInitiated) return;
    isEndCallInitiated = true;
    emit(RideRequestEndCall());
    callCubit.setCallingPageStatus(false);
  }

  void cancelRide(String? rideId) async {
    try {
      emit(CancelRideLoading());
      await RequestRideService().cancelRide(rideId);
      emit(CancelRideSuccess());
      currentRideCubit.reset();
      coolDownCubit.inactive();
      premiumTaxiCubit.reset();
    } catch (e) {
      emit(CancelRideError(message: e.toString()));
    }
  }

  void reset() {
    emit(RideInitial());
  }
}
