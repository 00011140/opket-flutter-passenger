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
  final referralController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _validate = false;
  bool _agreed = false;
  bool _shake = false;
  bool _showReferral = false;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () {
      focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
          SizedBox(height: AppSpacing.sm),

          // Referral code toggle
          GestureDetector(
            onTap: () => setState(() => _showReferral = !_showReferral),
            child: Row(
              children: [
                Icon(
                  _showReferral ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(
                  "Referral kodim bor",
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),

          if (_showReferral) ...[
            SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: referralController,
              onChanged: (value) {
                context.read<OtpCubit>().setManualReferralCode(value);
              },
              validator: null,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: "Referral kodni kiriting",
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
            ),
          ],

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
    referralController.dispose();
    super.dispose();
  }
}
