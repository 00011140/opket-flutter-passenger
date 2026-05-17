part of 'referral_code_cubit.dart';

sealed class ReferralCodeState {}

class ReferralCodeInitial extends ReferralCodeState {}

class ReferralCodeLoading extends ReferralCodeState {}

class ReferralCodeLoaded extends ReferralCodeState {
  final String code;
  ReferralCodeLoaded(this.code);
}

class ReferralCodeUnavailable extends ReferralCodeState {}
