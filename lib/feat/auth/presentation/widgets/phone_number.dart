import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/widgets/custom_textfield.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_cubit.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_state.dart';
import 'package:opket/feat/auth/presentation/widgets/terms_checkbox.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _validate = false;
  bool _agreed = false;
  bool _shake = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Telefon raqamingizni kiriting",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: AppSpacing.sm_md),
          CustomTextField(
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
          SizedBox(height: AppSpacing.md),
          if (Platform.isIOS)
            TermsCheckbox(
              value: _agreed,
              shake: _shake,
              onChanged: _onTermsCheckboxChanged,
            ),
          BlocBuilder<OtpCubit, OtpState>(
            builder: (context, state) {
              return AppIconButtonRectangle(
                text: "Saqlash",
                onPressed: onSave,
                isLoading: state.loading,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onTermsCheckboxChanged(bool? val) {
    if (val == null) return;
    setState(() {
      _agreed = val;
    });
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

    context.read<OtpCubit>().sendOtp(phone);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
