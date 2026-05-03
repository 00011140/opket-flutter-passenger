import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/balance/models/pay_fare_model.dart';
import 'package:opket/feat/balance/services/balance_service.dart';
import 'package:opket/core/models/error_response.dart';

part 'pay_fare_state.dart';

class PayFareCubit extends Cubit<PayFareState> {
  PayFareCubit() : super(PayFareInitial());

  void payFare(PayFareModel payFareData) async {
    emit(PayFareLoading());
    try {
      await BalanceService().payFare(payFareData);
      emit(PayFareSuccess());
    } on ErrorResponse catch (e) {
      emit(PayFareError(message: e.message));
    }
  }

  void reset() {
    emit(PayFareInitial());
  }
}
