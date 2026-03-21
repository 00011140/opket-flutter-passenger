import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/services/general_api_service.dart';

part 'verify_passenger_state.dart';

class VerifyPassengerCubit extends Cubit<VerifyPassengerState> {
  VerifyPassengerCubit() : super(VerifyPassengerInitial());

  Future<void> verifyPassenger() async {
    emit(VerifyPassengerLoading());
    try {
      await GeneralApiService().verifyPassenger();

      emit(VerifyPassengerSuccess());
    } catch (e) {
      emit(VerifyPassengerError(message: e.toString()));
    }
  }

  void reset() {
    emit(VerifyPassengerInitial());
  }
}
