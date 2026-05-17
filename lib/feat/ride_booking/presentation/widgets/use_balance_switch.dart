import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:opket/feat/active_ride/index.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';

class UseBalanceSwitch extends StatefulWidget {
  const UseBalanceSwitch({super.key});

  @override
  State<UseBalanceSwitch> createState() => _UseBalanceSwitchState();
}

class _UseBalanceSwitchState extends State<UseBalanceSwitch> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<BalanceCubit>();
    if (cubit.state is! BalanceSuccess) {
      cubit.loadBalance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, balanceState) {
        final balance = balanceState is BalanceSuccess
            ? balanceState.balance
            : 0;
        if (balance <= 0) return const SizedBox.shrink();

        return BlocBuilder<ActiveRideCubit, ActiveRideState>(
          builder: (context, rideState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Bonusdan foydalanish",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "${balance.formatWithThousands()} so'm mavjud",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                CupertinoSwitch(
                  value: rideState.useBalance,
                  onChanged: (value) => context
                      .read<ActiveRideCubit>()
                      .toggleUseBalance(value: value),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
