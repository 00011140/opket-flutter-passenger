import 'package:flutter/material.dart';
import 'package:opket/feat/balance/widgets/balance_info.dart';
import 'package:opket/core/utils/extensions.dart';

class BalanceTopUpContent extends StatelessWidget {
  const BalanceTopUpContent({super.key, required this.amount});
  final int amount;

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
      child: BalanceInfo(
        customMessage: [
          TextSpan(
            text: "Hamyoningizga ",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: "${amount.formatWithThousands()} so'm",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: " pul tushdi",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
        onPressed: () {
          Navigator.pop(context);
        },
        type: BalanceInfoType.success,
      ),
    );
  }
}
