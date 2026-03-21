import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/app_card.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/feat/ride/cubit/spam_guard_cubit.dart';
import 'package:opket/feat/ride/cubit/spam_guard_state.dart';

import 'app_icon_button_rectangle.dart';

class SpamGuardContent extends StatelessWidget {
  const SpamGuardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.block, size: 45, color: Colors.red),
            SizedBox(height: AppSpacing.md),
            BlocBuilder<SpamGuardCubit, SpamGuardState>(
              builder: (context, state) {
                return Text(
                  "${_format(state.timeLeft)} daqiqa kuting",
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              "Juda ko'p marotaba buyurtmani bekor qilganingiz uchun, yana buyurtma berish uchun kuting",
              style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            AppIconButtonRectangle(
              text: "OK",
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: const Color(0xFFFFE711),
              textColor: Colors.black,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
