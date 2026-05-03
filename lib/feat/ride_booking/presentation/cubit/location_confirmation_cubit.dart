import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/dashboard/controllers/dashboard_map_controller.dart';

class LocationConfirmationCubit extends Cubit<LocationConfirmtionState> {
  LocationConfirmationCubit() : super(LocationConfirmtionState());

  void setData({
    AnimationController? shakeController,
    GoogleMapsController? map,
    bool? isUserLocation,
  }) {
    emit(
      state.copyWith(
        map: map ?? state.map,
        shakeController: shakeController ?? state.shakeController,
        isUserLocation: isUserLocation ?? state.isUserLocation,
      ),
    );
  }
}

class LocationConfirmtionState {
  final AnimationController? shakeController;
  final GoogleMapsController? map;
  final bool isUserLocation;

  LocationConfirmtionState({
    this.shakeController,
    this.isUserLocation = true,
    this.map,
  });

  LocationConfirmtionState copyWith({
    AnimationController? shakeController,
    GoogleMapsController? map,
    bool? isUserLocation,
  }) {
    return LocationConfirmtionState(
      shakeController: shakeController ?? this.shakeController,
      map: map ?? this.map,
      isUserLocation: isUserLocation ?? this.isUserLocation,
    );
  }
}
