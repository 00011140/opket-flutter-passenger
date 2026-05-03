import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/theme/spacing.dart';
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
          fullHeight: true,
          borderRadius: 12,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          onTap: () {
            context.read<SelectedRideOptionsCubit>().toggleOption(optionId);
          },
          child: Row(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? const Color(0xFF2CCC31) : null,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF2CCC31)
                        : Colors.grey.shade400,
                  ),
                ),
              ),

              // Icon(Icons.circle_outlined, size: 30, color: Colors.grey.shade300),
              SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 16),
                  ),
                  Text("+$price so'm"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
