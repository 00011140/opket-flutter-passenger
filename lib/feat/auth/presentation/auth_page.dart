import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/loading_overlay.dart';
import 'package:opket/core/widgets/samsung_bottom_sheet.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_cubit.dart';
import 'package:opket/feat/auth/presentation/widgets/otp_code.dart';
import 'package:opket/feat/auth/presentation/widgets/phone_number.dart';

import 'cubit/otp_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return SamsungBottomSheet(
      child: BlocBuilder<OtpCubit, OtpState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: LoadingOverlay(
              isLoading: state.loading,
              child: switch (state.step) {
                OtpStep.codeSent => OtpCode(state: state),
                _ => PhoneNumber(),
              },
            ),
          );
        },
      ),
    );
  }
}
