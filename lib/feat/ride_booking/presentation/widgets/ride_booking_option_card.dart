import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/constants/app_icons_v3.dart';
import 'package:opket/core/theme/colors.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/feat/ride_options/index.dart';

class RideBookingOptionCard extends StatelessWidget {
  const RideBookingOptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.optionId,
  });
  final String title;
  final int price;
  final String optionId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectedRideOptionsCubit, List<String>>(
      builder: (context, selectedOptions) {
        final selected = selectedOptions.contains(optionId);
        return AppCard(
          color: const Color.fromARGB(255, 247, 247, 247),
          boxShadow: false,
          borderRadius: 12,
          border: Border.all(color: Colors.grey.shade100),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: AppSpacing.md),
          onTap: () {
            context.read<SelectedRideOptionsCubit>().toggleOption(optionId);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: selected ? Colors.black : Colors.grey,
                ),
              ),
              Text(
                "+${price.formatWithThousands()} so'm",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
