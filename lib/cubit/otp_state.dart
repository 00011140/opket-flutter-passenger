import 'package:equatable/equatable.dart';
import 'package:opket/components/OtpInputField.dart';

enum OtpStep { enterPhone, codeSent }

class OtpState extends Equatable {
  final OtpStep step;
  final bool loading;
  final String? error;
  final OtpCodeState codeState;
  final int? phone;

  const OtpState({
    this.step = OtpStep.enterPhone,
    this.loading = false,
    this.error,
    this.codeState = OtpCodeState.idle,
    this.phone,
  });

  OtpState copyWith({
    OtpStep? step,
    bool? loading,
    String? error,
    OtpCodeState? codeState,
    int? phone,
  }) => OtpState(
    step: step ?? this.step,
    loading: loading ?? this.loading,
    error: error ?? this.error,
    codeState: codeState ?? this.codeState,
    phone: phone ?? this.phone,
  );

  // Map<String, dynamic> toJson() => {'step': step};

  @override
  List<Object?> get props => [step, loading, error, codeState];
}
