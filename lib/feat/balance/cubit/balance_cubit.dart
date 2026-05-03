import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/balance/models/pay_fare_model.dart';
import 'package:opket/feat/balance/services/balance_service.dart';
import 'package:opket/core/services/socket_service.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final socket = SocketService.instance;

  late final StreamSubscription _sub;
  late final StreamSubscription _subBalanceTopUp;

  BalanceCubit() : super(BalanceInitial()) {
    _sub = socket.onBalanceDeductionRequest.listen(
      _handleBalanceDeductionRequest,
    );

    _subBalanceTopUp = socket.onBalanceTopUp.listen(_handleBalanceTopUp);
  }

  void _handleBalanceDeductionRequest(data) {
    final amount = data['amount'];
    final driverId = data['driverId'];
    final driverName = data['driverName'];

    emit(
      BalanceDeductionRequest(
        payFareData: PayFareModel(
          driverName: driverName,
          amount: amount,
          driverId: driverId,
        ),
      ),
    );
  }

  void _handleBalanceTopUp(data) {
    final amount = data['amount'];
    emit(BalanceTopUp(amount: amount));
  }

  void declineRideChange(String driverId) {
    socket.declineRideChange(driverId);
  }

  Future<void> loadBalance() async {
    emit(BalanceLoading());
    try {
      final balance = await BalanceService().getBalance();
      emit(BalanceSuccess(balance: balance, canReceiveOffers: balance > 0));
    } catch (e) {
      emit(BalanceError(message: e.toString()));
    }
  }

  void reset() {
    emit(BalanceInitial());
  }

  @override
  Future<void> close() {
    _sub.cancel();
    _subBalanceTopUp.cancel();
    return super.close();
  }
}
