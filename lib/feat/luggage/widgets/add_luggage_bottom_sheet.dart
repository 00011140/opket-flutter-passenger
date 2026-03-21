import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/app_button_rectangle.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';
import 'package:opket/feat/balance/cubit/pay_fare_cubit.dart';
import 'package:opket/feat/luggage/cubit/luggage_cubit.dart';
import 'package:opket/utils/extensions.dart';

class AddLuggageBottomSheet extends StatefulWidget {
  const AddLuggageBottomSheet({
    super.key,
    required this.luggageCharge,
    required this.driverId,
  });
  final int luggageCharge;
  final String driverId;

  @override
  State<AddLuggageBottomSheet> createState() => _AddLuggageBottomSheetState();
}

class _AddLuggageBottomSheetState extends State<AddLuggageBottomSheet> {
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Haydovchi bagaj qo'shmoqchi, tasdiqlaysizmi?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 18),
              Text(
                "Yo'l haqqiga qo'shiladi:",
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                "+${widget.luggageCharge.formatWithThousands()} so'm",
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: AppButtonRectangle(
                      text: "Yo'q",
                      onPressed: () {
                        context.read<LuggageCubit>().declineLuggage(
                          widget.driverId,
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
                        context.read<LuggageCubit>().confirmLuggage(
                          widget.driverId,
                        );
                        Navigator.pop(context);
                      },
                      backgroundColor: const Color.fromARGB(255, 253, 211, 0),
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
