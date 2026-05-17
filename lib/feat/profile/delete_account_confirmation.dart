import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/auth/presentation/cubit/auth_cubit.dart';

class DeleteAccountConfirmationDialog extends StatefulWidget {
  const DeleteAccountConfirmationDialog({super.key});

  @override
  State<DeleteAccountConfirmationDialog> createState() =>
      _DeleteAccountConfirmationDialogState();
}

class _DeleteAccountConfirmationDialogState
    extends State<DeleteAccountConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Ishonchingiz komilmi ?",
              style: TextStyle(
                // fontFamily: 'WorkSans',
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            const Text(
              "Hisobingizdan chiqasiz. Bonuslaringiz, referral kodingiz va boshqa ma'lumotlaringiz saqlanib qoladi.",
              style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppIconButtonRectangle(
                    text: "YO'Q",
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.grey.shade200,
                    textColor: Colors.black,
                    height: 55,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppIconButtonRectangle(
                    text: "HA",
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<AuthCubit>().logout();
                    },
                    backgroundColor: const Color(0xFFFFE711),
                    textColor: Colors.black,
                    height: 55,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
