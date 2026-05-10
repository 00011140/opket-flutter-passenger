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
      listenWhen: (prev, curr) =>
          (prev.codeState != OtpCodeState.success && curr.codeState == OtpCodeState.success) ||
          (prev.step != OtpStep.registered && curr.step == OtpStep.registered),
      listener: (context, state) {
        if (state.codeState == OtpCodeState.success && state.step == OtpStep.codeSent) {
          context.read<OtpCubit>().registerUser();
        } else if (state.step == OtpStep.registered) {
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
            BlocListener<OtpCubit, OtpState>(
              listenWhen: (prev, curr) =>
                  prev.codeState != curr.codeState &&
                  curr.codeState == OtpCodeState.error,
              listener: (context, state) async {
                await Future.delayed(const Duration(milliseconds: 500));

                _otpCtrl.clear();

                // Optional: reset state so next error can trigger again
                context.read<OtpCubit>().emit(
                  state.copyWith(codeState: OtpCodeState.idle),
                );
              },
              child: OtpInputField(
                controller: _otpCtrl,
                focusNode: otpCodeFocusNode,
                state: widget.state.codeState,
                onCompleted: (code) {
                  context.read<OtpCubit>().verifyOtp(int.parse(code));
                },
              ),
            ),
            const SizedBox(height: 20),
            !canResend
                ? Text(
                    "${seconds}s dan keyin kodni qayta olishingiz mumkin",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFa1a1a3), fontSize: 20),
                  )
                : Align(
                    alignment: AlignmentGeometry.center,
                    child: AppButton(
                      text: "Kodni qayta olish",
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
