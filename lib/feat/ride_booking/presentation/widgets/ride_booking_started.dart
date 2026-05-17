import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/constants/app_icons_v3.dart';
import 'package:opket/core/services/discount_config_service.dart';
import 'package:opket/core/theme/colors.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/feat/active_ride/index.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';

class RideBookingStarted extends StatefulWidget {
  const RideBookingStarted({super.key});

  @override
  State<RideBookingStarted> createState() => _RideBookingStartedState();
}

class _RideBookingStartedState extends State<RideBookingStarted> {
  DiscountConfig _discount = DiscountConfigService.current;

  @override
  void initState() {
    super.initState();
    DiscountConfigService.load().then((cfg) {
      if (!mounted) return;
      setState(() => _discount = cfg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveRideCubit, ActiveRideState>(
      builder: (context, state) {
        final RideProgress? progress = state.progress;
        if (state.status != RideStatus.started) {
          return const SizedBox.shrink();
        }

        final fare = progress?.fare ?? 0;

        return BlocBuilder<BalanceCubit, BalanceState>(
          builder: (context, balanceState) {
            final balance = balanceState is BalanceSuccess
                ? balanceState.balance
                : 0;
            final useBalance = state.useBalance;
            return Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                      horizontal: AppSpacing.md,
                    ),
                    borderRadius: 18,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(AppIconsV3.mmoneyIcon, size: 40),
                        Flexible(
                          child: _FareText(
                            fare: fare,
                            discount: _discount,
                            balance: useBalance ? balance : 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                    horizontal: AppSpacing.md,
                  ),
                  borderRadius: 18,
                  child: Text(
                    "${progress?.distance.toStringAsFixed(2)} km",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _FareText extends StatelessWidget {
  final int fare;
  final DiscountConfig discount;
  final int balance;

  const _FareText({
    required this.fare,
    required this.discount,
    this.balance = 0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasDiscount = discount.appliesTo(fare);
    final baseFare = hasDiscount ? discount.discountedFare(fare) : fare;
    final displayFare = (baseFare - balance).clamp(0, baseFare);
    final balanceApplied = balance > 0 && balance <= baseFare;

    return Stack(
      clipBehavior: Clip.none,
      // mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasDiscount || balanceApplied)
          Positioned(
            top: -15,
            right: 0,
            child: Text(
              "${fare.formatWithThousands()} so'm",
              style: textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.grey.shade400,
                decorationThickness: 2,
              ),
            ),
          ),
        Text(
          "${displayFare.formatWithThousands()} so'm",
          textAlign: TextAlign.end,
          style: textTheme.displaySmall?.copyWith(
            color: (hasDiscount || balanceApplied) ? Colors.black : null,
            fontWeight: FontWeight.w500,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
