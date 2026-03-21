import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/OtpInputField.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/components/custom_textfield.dart';
import 'package:opket/components/otp_code_verification.dart';
import 'package:opket/components/terms_checkbox.dart';
import 'package:opket/cubit/create_user_cubit.dart';
import 'package:opket/cubit/otp_sms_cubit.dart';
import 'package:opket/cubit/otp_state.dart';

import 'samsung_bottom_sheet.dart';

class PhoneNumberBottomSheet extends StatefulWidget {
  const PhoneNumberBottomSheet({super.key});

  @override
  State<PhoneNumberBottomSheet> createState() => _PhoneNumberBottomSheetState();
}

class _PhoneNumberBottomSheetState extends State<PhoneNumberBottomSheet> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _validate = false;
  bool _agreed = false;
  bool _shake = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      if (!focusNode.hasFocus) focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SamsungBottomSheet(
      child: BlocListener<CreateUserCubit, CreateUserState>(
        listener: (context, state) {
          if (state is CreateUserSuccess) {
            context.read<OtpSmsCubit>().reset();
            Navigator.pop(context);
          } else if (state is CreateUserError) {
            context.read<OtpSmsCubit>().reset();
          }
        },
        child: BlocConsumer<OtpSmsCubit, OtpState>(
          listener: (context, state) {
            if (state.codeState == OtpCodeState.success &&
                state.phone != null) {
              context.read<CreateUserCubit>().createUser(state.phone!);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.step == OtpStep.enterPhone)
                      Text(
                        "Telefon raqamingizni kiriting",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'WorkSans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (state.step == OtpStep.enterPhone)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: CustomTextField(
                          focusNode: focusNode,
                          controller: controller,
                          onChanged: (value) {
                            if (_validate) _formKey.currentState!.validate();
                          },
                          onFieldSubmitted: (_) => onSave(),
                          isPhone: true,
                          hintText: "00 000-00-00",
                          filled: false,
                          isBig: true,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    if (Platform.isIOS && state.step == OtpStep.enterPhone)
                      TermsCheckbox(
                        value: _agreed,
                        shake: _shake,
                        onChanged: (val) {
                          if (val == null) return;
                          setState(() {
                            _agreed = val;
                          });
                        },
                      ),
                    if (state.step == OtpStep.codeSent)
                      OtpCodeVerification(state: state),
                    if (state.step == OtpStep.enterPhone)
                      AppIconButtonRectangle(
                        text: "Saqlash",
                        onPressed: onSave,
                        isLoading: state.loading,
                        size: AppButtonSize.medium,
                        backgroundColor: const Color(0xFFFFE711),
                        textColor: Colors.black,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void onSave() async {
    if (Platform.isIOS && !_agreed) {
      setState(() {
        _shake = true;
      });
      return;
    }
    setState(() => _validate = true);
    if (!_formKey.currentState!.validate()) return;

    final digits = controller.text.replaceAll(RegExp(r'\D'), '');
    final phone = int.parse(digits);

    context.read<OtpSmsCubit>().sendOtp(phone);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
