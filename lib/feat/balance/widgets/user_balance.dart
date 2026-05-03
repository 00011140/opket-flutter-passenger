
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/shimmer_loader.dart';
import 'package:opket/core/constants/app_icons.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';
import 'package:opket/feat/balance/models/pay_fare_model.dart';
import 'package:opket/feat/balance/widgets/balance_deduction_bottom_sheet_content.dart';
import 'package:opket/feat/balance/widgets/balance_top_up.dart';
import 'package:opket/core/services/audio_service.dart';
import 'package:opket/core/utils/extensions.dart';

class UserBalance extends StatefulWidget {
  const UserBalance({super.key});

  @override
  State<UserBalance> createState() => _UserBalanceState();
}

class _UserBalanceState extends State<UserBalance> {
  int balance = 0;

  @override
  void initState() {
    final state = context.read<BalanceCubit>().state;
    if (state is! BalanceSuccess) {
      context.read<BalanceCubit>().loadBalance();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BalanceCubit, BalanceState>(
      listener: (context, state) {
        if (state is BalanceDeductionRequest) {
          _showBalanceDeductionBottomsheet(state.payFareData);
        } else if (state is BalanceTopUp) {
          context.read<BalanceCubit>().loadBalance();
          _showBalanceTopUpBottomsheet(state.amount);
        }
      },
      builder: (context, state) {
        if (state is BalanceSuccess) balance = state.balance;

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actionsPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 20,
                  ).copyWith(bottom: 10),
                  backgroundColor: Colors.white,
                  title: Text(
                    "Balansingizda ${balance.formatWithThousands()} so'm bor",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    "Haydovchidan yo'l haqqini balansingizdan yechib olishini so'rang",
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Yopish'),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
              horizontal: AppSpacing.sm_md,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(AppIcons.wallet, size: 28),
                SizedBox(width: 5),
                if (state is BalanceLoading)
                  ShimmerLoader(borderRadius: 12, child: Text("00 000")),
                if (state is! BalanceLoading)
                  Text(
                    balance.formatWithThousands(),
                    style: TextStyle(fontSize: 18),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBalanceDeductionBottomsheet(PayFareModel payFareData) {
    AudioService().playSound('balance_deduction_request.m4a');

    showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      isScrollControlled: false,
      enableDrag: false,
      builder: (context) {
        return BalanceDeductionBottomSheetContent(payFareData: payFareData);
      },
    );
  }

  void _showBalanceTopUpBottomsheet(int amount) {
    AudioService().playSound("topup_balance.m4a");
    showModalBottomSheet(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.22),
      isScrollControlled: false,
      enableDrag: false,
      builder: (context) {
        return BalanceTopUpContent(amount: amount);
      },
    );
  }
}
