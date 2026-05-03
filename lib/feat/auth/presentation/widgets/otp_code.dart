import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/OtpInputField.dart';
import 'package:opket/core/widgets/allow_location_dialog.dart';
import 'package:opket/core/widgets/app_button.dart';
import 'package:opket/feat/auth/presentation/cubit/auth_cubit.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_cubit.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_state.dart';

import 'package:opket/core/utils/extensions.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpCode extends StatefulWidget {
  const OtpCode({super.key, required this.state});
  final OtpState state;

  @override
  State<OtpCode> createState() => _OtpCodeState();
}

class _OtpCodeState extends State<OtpCode> with CodeAutoFill {
  final _otpCtrl = TextEditingController();
  final otpCodeFocusNode = FocusNode();
  // OtpState otpState = OtpState.idle;
  int seconds = 60;
  Timer? _timer;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    otpCodeFocusNode.requestFocus();
    _start();
    listenForCode();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.isNotEmpty) {
      _otpCtrl.text = code!;
      context.read<OtpCubit>().verifyOtp(int.parse(code!));
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      if (seconds == 0) {
        setState(() => canResend = true);
        t.cancel();
      } else {
        setState(() => seconds--);
      }
    });
  }

  @override
  void dispose() {
    cancel(); // CodeAutoFill
    _timer?.cancel();
    _otpCtrl.dispose();
    otpCodeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final phone = context.read<OtpSmsCubit>().phoneNumber;
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        final step = state.step;
        final codeState = state.codeState;
        if (codeState == OtpCodeState.success && step == OtpStep.codeSent) {
          context.read<OtpCubit>().registerUser();
        } else if (step == OtpStep.registered) {
          context.read<AuthCubit>().authenticated();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "SMS kodni kiriting",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text.rich(
              textAlign: TextAlign.center,

              TextSpan(
                text: "${widget.state.phone?.addUzbCode().formatUzbekPhone()}",
                style: TextStyle(fontSize: 14, color: Colors.blue),
                children: [
                  TextSpan(
                    text: " raqamiga 4 xonalik tasdiqlash kodi yuborildi",
                    style: TextStyle(fontSize: 14, color: Color(0xFFa1a1a3)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),
            OtpInputField(
              controller: _otpCtrl,
              focusNode: otpCodeFocusNode,
              state: widget.state.codeState,
              onCompleted: (code) {
                context.read<OtpCubit>().verifyOtp(int.parse(code));

                // context.read<OtpSmsCubit>().verifyOtp(code);
                // setState(() => hasOtpError = false);
                // sl<PhoneVerificationCubit>().verifyOtp(code);
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: AlignmentGeometry.center,
              child: AppButton(
                text: canResend
                    ? "Kodni qayta olish"
                    : "${seconds}s dan keyin qayta oling",
                isLoading: state.loading,
                enabled: canResend,
                onPressed: resendCode,
              ),
            ),
          ],
        );
      },
    );
  }

  void resendCode() {
    context.read<OtpCubit>().reset();
    setState(() {
      canResend = false;
      seconds = 60;
    });
  }
}
