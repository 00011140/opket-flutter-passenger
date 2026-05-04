import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/constants/app_icons_v3.dart';
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
          color: const Color.fromARGB(255, 247, 247, 247),
          boxShadow: false,
          borderRadius: 12,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: AppSpacing.md),
          onTap: () {
            context.read<SelectedRideOptionsCubit>().toggleOption(optionId);
          },
          child: Opacity(
            opacity: selected ? 1 : 0.5,
            child: Row(
              children: [
                // AnimatedContainer(
                //   duration: Duration(milliseconds: 200),
                //   width: 22,
                //   height: 22,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: selected ? const Color(0xFF2CCC31) : null,
                //     border: Border.all(
                //       color: selected
                //           ? const Color(0xFF2CCC31)
                //           : Colors.grey.shade400,
                //     ),
                //   ),
                // ),

                // Icon(Icons.circle_outlined, size: 30, color: Colors.grey.shade300),
                // SizedBox(width: AppSpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Icon(AppIconsV3.deliveryIcon, size: 35),
                    // SizedBox(height: AppSpacing.sm),
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "+$price so'm",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
