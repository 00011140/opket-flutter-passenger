import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/toast_service.dart';
import 'package:opket/cubit/premium_taxi_state.dart';
import 'package:opket/feat/fare_by_options/fare_cubit.dart';
import 'package:opket/services/socket_service.dart';

class PremiumTaxiCubit extends Cubit<PremiumTaxiState> {
  FareCubit fareCubit;
  late final StreamSubscription _sub;
  final socket = SocketService.instance;

  PremiumTaxiCubit(this.fareCubit) : super(PremiumTaxiState()) {
    _sub = SocketService.instance.onNoPremiumDrivers.listen(
      _handleNoPremiumDrivers,
    );
  }

  void _handleNoPremiumDrivers(dynamic data) {
    final isAvailable = data['isAvailable'] as bool;

    if (!isAvailable) {
      ToastService.showAutoHide(
        "☹️ Barcha premium taxi haydovchilari hozirda band",
      );

      emit(
        state.copyWith(premium: false, status: PremiumTaxiStatus.notAvailable),
      );
      reset();
    }
  }

  void setData(bool value) {
    if (value) {
      socket.hasPremiumCars();
    }
    emit(state.copyWith(premium: value));
  }

  void reset() {
    emit(PremiumTaxiState());
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
