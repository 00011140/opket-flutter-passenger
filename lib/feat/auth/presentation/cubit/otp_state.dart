import 'package:equatable/equatable.dart';
import 'package:opket/core/widgets/OtpInputField.dart';

enum OtpStep { idle, codeSent, registered }

class OtpState extends Equatable {
  final OtpStep step;
  final bool loading;
  final String? error;
  final OtpCodeState codeState;
  final int? phone;
  final String? manualReferralCode;

  const OtpState({
    this.step = OtpStep.idle,
    this.loading = false,
    this.error,
    this.codeState = OtpCodeState.idle,
    this.phone,
    this.manualReferralCode,
  });

  OtpState copyWith({
    OtpStep? step,
    bool? loading,
    String? error,
    OtpCodeState? codeState,
    int? phone,
    String? manualReferralCode,
    bool clearManualReferralCode = false,
  }) => OtpState(
    step: step ?? this.step,
    loading: loading ?? this.loading,
    error: error ?? this.error,
    codeState: codeState ?? this.codeState,
    phone: phone ?? this.phone,
    manualReferralCode: clearManualReferralCode ? null : (manualReferralCode ?? this.manualReferralCode),
  );

  @override
  List<Object?> get props => [step, loading, error, codeState, manualReferralCode];
}
