part of 'otp_sms_cubit.dart';

abstract class OtpSmsState {}

class OtpSmsInitial extends OtpSmsState {}

class SendOtpLoading extends OtpSmsState {}

class SendOtpError extends OtpSmsState {
  final String message;
  SendOtpError({required this.message});
}

class SendOtpSuccess extends OtpSmsState {}

class VerifyOtpLoading extends OtpSmsState {}

class VerifyOtpError extends OtpSmsState {
  final String message;
  VerifyOtpError({required this.message});
}

class VerifyOtpSuccess extends OtpSmsState {}
