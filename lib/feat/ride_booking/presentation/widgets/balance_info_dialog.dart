import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/constants/app_icons_v3.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';

class BalanceInfoDialog extends StatefulWidget {
  const BalanceInfoDialog({super.key});

  @override
  State<BalanceInfoDialog> createState() => _BalanceInfoDialogState();
}

class _BalanceInfoDialogState extends State<BalanceInfoDialog> {
  bool _demoOn = false;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _demoOn = !_demoOn);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF9E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                AppIconsV3.mmoneyIcon,
                size: 28,
                color: Color(0xFFFFCC00),
              ),
            ),
            SizedBox(height: AppSpacing.sm_md),
            BlocBuilder<BalanceCubit, BalanceState>(
              builder: (context, state) {
                final balance = state is BalanceSuccess ? state.balance : null;
                return Text(
                  balance != null
                      ? "Bonuslar: ${balance.formatWithThousands()} so'm"
                      : "Balansingiz",
                  style: const TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
            SizedBox(height: AppSpacing.sm),
            const Text(
              "Bonuslardan yo'l haqqini to'lashda foydalanishingiz mumkin.\n\nTaksi chaqirganingizda \"Bonusdan foydalanish\" tugamsini quyidagicha yoqish kifoya",
              style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md_lg),
            Divider(height: 1, color: Colors.grey.shade200),
            SizedBox(height: AppSpacing.md),
            _DemoBalanceSwitch(on: _demoOn),
          ],
        ),
      ),
    );
  }
}

class _DemoBalanceSwitch extends StatelessWidget {
  const _DemoBalanceSwitch({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, balanceState) {
        final balance = balanceState is BalanceSuccess
            ? balanceState.balance
            : 0;
        if (balance <= 0) return const SizedBox.shrink();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Bonusdan foydalanish",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                Text(
                  "${balance.formatWithThousands()} so'm mavjud",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            IgnorePointer(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: CupertinoSwitch(
                  key: ValueKey(on),
                  value: on,
                  onChanged: (_) {},
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
