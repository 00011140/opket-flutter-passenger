import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/phone_number_bottom_sheet.dart';
import 'package:opket/cubit/otp_sms_cubit.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OtpSmsCubit(),
      child: PhoneNumberBottomSheet(),
    );
  }
}
