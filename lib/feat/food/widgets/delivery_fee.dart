import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/feat/food/cubit/delivery_fee_cubit.dart';
import 'package:opket/utils/extensions.dart';

class DeliveryFee extends StatefulWidget {
  const DeliveryFee({super.key});

  @override
  State<DeliveryFee> createState() => _DeliveryFeeState();
}

class _DeliveryFeeState extends State<DeliveryFee> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryFeeCubit, DeliveryFeeState>(
      builder: (context, state) {
        if (state is DeliveryFeeLoaded) {
          final deliveryFee = state.data;

          return Column(
            children: [
              _DetailRow(
                label: "Yetkazib berish",
                value: deliveryFee == 0
                    ? "Bepul"
                    : deliveryFee.formatUzbekSoumFromCents(),
                valueStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: deliveryFee == 0
                      ? const Color(0xFF059669)
                      : const Color(0xFF111827),
                ),
              ),
            ],
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final baseValueStyle = TextStyle(
      fontSize: isTotal ? 16 : 14,
      fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
      color: const Color(0xFF111827),
    );

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
                color: Colors.orange,
              ),
            ),
          ),
          Text(value, style: valueStyle ?? baseValueStyle),
        ],
      ),
    );
  }
}
