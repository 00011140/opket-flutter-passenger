import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/constants/app_icons_v3.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/feat/active_ride/index.dart';

class RideBookingStarted extends StatelessWidget {
  const RideBookingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveRideCubit, ActiveRideState>(
      builder: (context, state) {
        RideProgress? progress = state.progress;
        if (state.status == RideStatus.started) {
          return Row(
            children: [
              Expanded(
                child: AppCard(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.md,
                  ),
                  borderRadius: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(AppIconsV3.mmoneyIcon, size: 40),
                      Text(
                        "${progress?.fare.formatWithThousands()} so'm",
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              AppCard(
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.md,
                ),
                borderRadius: 18,
                child: Text(
                  "${progress?.distance.toStringAsFixed(2)} km",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
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
