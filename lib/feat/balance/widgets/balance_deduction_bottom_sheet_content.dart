import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/app_button_rectangle.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';
import 'package:opket/feat/balance/cubit/pay_fare_cubit.dart';
import 'package:opket/feat/balance/models/pay_fare_model.dart';
import 'package:opket/feat/balance/widgets/balance_info.dart';
import 'package:opket/core/utils/extensions.dart';

class BalanceDeductionBottomSheetContent extends StatefulWidget {
  const BalanceDeductionBottomSheetContent({
    super.key,
    required this.payFareData,
  });
  final PayFareModel payFareData;

  @override
  State<BalanceDeductionBottomSheetContent> createState() =>
      _BalanceDeductionBottomSheetContentState();
}

class _BalanceDeductionBottomSheetContentState
    extends State<BalanceDeductionBottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        16,
      ).copyWith(bottom: MediaQuery.of(context).viewPadding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: BlocConsumer<PayFareCubit, PayFareState>(
        listener: (context, state) {
          if (state is PayFareSuccess) {
            context.read<BalanceCubit>().loadBalance();
          }
        },
        builder: (context, state) {
          if (state is PayFareSuccess) {
            return BalanceInfo(
              message: "To'lov muvaffaqiyatli amalga oshirildi",
              onPressed: () {
                Navigator.pop(context);
                context.read<PayFareCubit>().reset();
              },
              type: BalanceInfoType.success,
            );
          }
          if (state is PayFareError) {
            return BalanceInfo(
              message: state.message,
              onPressed: () {
                Navigator.pop(context);
                context.read<PayFareCubit>().reset();
              },
              type: BalanceInfoType.error,
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Haydovchiga pul o'tkazilsinmi?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    widget.payFareData.driverName,
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.account_balance_wallet),
                  SizedBox(width: 10),
                  Text(
                    "-${widget.payFareData.amount.formatWithThousands()} so'm",
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: AppButtonRectangle(
                      text: "Yo'q",
                      onPressed: () {
                        context.read<BalanceCubit>().declineRideChange(
                          widget.payFareData.driverId,
                        );
                        Navigator.pop(context);
                      },
                      backgroundColor: const Color.fromARGB(255, 219, 219, 219),
                      textColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: AppButtonRectangle(
                      text: "Ha",
                      isLoading: state is PayFareLoading,
                      onPressed: () {
                        context.read<PayFareCubit>().payFare(
                          widget.payFareData,
                        );
                      },
                      backgroundColor: const Color(0xFFFDD300),
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
