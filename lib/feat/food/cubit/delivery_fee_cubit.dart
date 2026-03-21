import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:opket/feat/food/models/delivery_fee_request_body.dart';
import 'package:opket/feat/food/services/food_service.dart';

part 'delivery_fee_state.dart';

class DeliveryFeeCubit extends Cubit<DeliveryFeeState> {
  DeliveryFeeCubit() : super(DeliveryFeeInitial());

  Location? _lastUserLocation;
  Location? _lastRestaurantLocation;

  int? _lastSubtotal;
  int? _lastFreeOverAmount;

  int? _cachedFee;

  static const double _thresholdMeters = 20;

  Future<void> calculateDeliveryFee(DeliveryFeeRequestBody requestBody) async {
    try {
      final restaurant = requestBody.origin; // restaurant
      final user = requestBody.destination; // user
      final subtotal = requestBody.subtotal;
      final freeOverAmount = requestBody.freeOverAmount;

      final hasCache =
          _cachedFee != null &&
          _lastUserLocation != null &&
          _lastRestaurantLocation != null &&
          _lastSubtotal != null &&
          _lastFreeOverAmount != null;

      final isSameRestaurant =
          hasCache &&
          _lastRestaurantLocation!.lat == restaurant.lat &&
          _lastRestaurantLocation!.lng == restaurant.lng;

      final isNearUser =
          hasCache && _isWithinThreshold(_lastUserLocation!, user);

      final isSameSubtotal = hasCache && _lastSubtotal == subtotal;

      final isSameFreeRule = hasCache && _lastFreeOverAmount == freeOverAmount;

      if (hasCache &&
          isSameRestaurant &&
          isNearUser &&
          isSameSubtotal &&
          isSameFreeRule) {
        emit(DeliveryFeeLoaded(_cachedFee!));
        return;
      }

      /// Otherwise call backend
      emit(DeliveryFeeLoading());

      final fee = await FoodService().calculateDeliveryFee(requestBody);

      /// Save cache
      _cachedFee = fee;
      _lastUserLocation = user;
      _lastRestaurantLocation = restaurant;
      _lastSubtotal = subtotal;
      _lastFreeOverAmount = freeOverAmount;

      emit(DeliveryFeeLoaded(fee));
    } catch (e) {
      emit(DeliveryFeeError(e.toString()));
    }
  }

  bool _isWithinThreshold(Location a, Location b) {
    final distance = Geolocator.distanceBetween(a.lat, a.lng, b.lat, b.lng);

    return distance <= _thresholdMeters;
  }

  void reset() {
    emit(DeliveryFeeInitial());
  }
}
