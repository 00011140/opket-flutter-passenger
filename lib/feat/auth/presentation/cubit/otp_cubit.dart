import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/OtpInputField.dart';
import 'package:opket/core/env.dart';
import 'package:opket/feat/auth/domain/usecases/register_user.dart';
import 'package:opket/feat/auth/domain/usecases/send_otp.dart';
import 'package:opket/feat/auth/domain/usecases/verify_otp.dart';

import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  final SendOtp sendOtpUsecase;
  final VerifyOtp verifyOtpUsecase;
  final RegisterUser registerUserUsecase;

  OtpCubit({
    required this.sendOtpUsecase,
    required this.verifyOtpUsecase,
    required this.registerUserUsecase,
  }) : super(OtpState());

  void sendOtp(int phone) async {
    try {
      emit(state.copyWith(loading: true));

      if (Env.isDev) {
        emit(
          state.copyWith(step: OtpStep.codeSent, phone: phone, loading: false),
        );
        return;
      }

      final result = await sendOtpUsecase(phone);

      emit(
        result.fold(
          (l) => state.copyWith(error: l.message),
          (r) => state.copyWith(
            step: OtpStep.codeSent,
            phone: phone,
            loading: false,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  void verifyOtp(int otp) async {
    try {
      if (Env.isDev) {
        emit(state.copyWith(codeState: OtpCodeState.success));
        return;
      }

      final params = VerifyOtpParams(otp: otp, phone: state.phone!);
      final result = await verifyOtpUsecase(params);

      emit(
        result.fold((l) => state.copyWith(error: l.message), (r) {
          return state.copyWith(
            codeState: r ? OtpCodeState.success : OtpCodeState.error,
            loading: false,
          );
        }),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  void setManualReferralCode(String code) {
    emit(state.copyWith(manualReferralCode: code.trim().isEmpty ? null : code.trim()));
  }

  void registerUser() async {
    try {
      emit(state.copyWith(loading: true));

      final params = RegisterUserParams(
        phone: state.phone!,
        manualReferralCode: state.manualReferralCode,
      );
      final result = await registerUserUsecase(params);

      emit(
        result.fold(
          (l) => state.copyWith(
            error: l.message,
            loading: false,
            codeState: OtpCodeState.idle,
          ),
          (r) {
            return state.copyWith(
              step: OtpStep.registered,
              codeState: OtpCodeState.idle,
              loading: false,
              error: null,
            );
          },
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  void reset() {
    emit(OtpState());
  }
}
