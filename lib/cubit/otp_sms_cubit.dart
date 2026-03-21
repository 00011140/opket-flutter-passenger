import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/OtpInputField.dart';
import 'package:opket/core/env.dart';
import 'package:opket/cubit/otp_state.dart';
import 'package:opket/services/sms_api_service.dart';

part 'otp_sms_state.dart';

class OtpSmsCubit extends Cubit<OtpState> {
  final SmsApiService smsApiService = SmsApiService();
  String? requestId;

  OtpSmsCubit() : super(OtpState());

  static const testPhone = 992707255;

  Future<void> sendOtp(int phone) async {
    emit(state.copyWith(loading: true));
    try {
      if (Env.isDev || phone == testPhone) {
        emit(
          state.copyWith(loading: false, step: OtpStep.codeSent, phone: phone),
        );
        return;
      }
      await smsApiService.sendOtpCode(phone);
      emit(
        state.copyWith(loading: false, step: OtpStep.codeSent, phone: phone),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void verifyOtp(String enteredOtp) async {
    if (Env.isDev || state.phone == testPhone) {
      emit(state.copyWith(loading: false, codeState: OtpCodeState.success));
      return;
    }
    emit(state.copyWith(loading: true));

    try {
      final status = await smsApiService.verifyOtpCode(
        phone: state.phone!,
        enteredOtp: int.parse(enteredOtp),
      );

      if (status) {
        emit(state.copyWith(loading: false, codeState: OtpCodeState.success));
      } else {
        emit(state.copyWith(loading: false, codeState: OtpCodeState.error));
      }
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void reset() {
    emit(OtpState());
  }
}
