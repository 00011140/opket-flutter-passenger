import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/constants/app_icons_v3.dart';
import 'package:opket/core/services/discount_config_service.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/feat/active_ride/index.dart';

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
                    Flexible(child: _FareText(fare: fare, discount: _discount)),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FareText extends StatelessWidget {
  final int fare;
  final DiscountConfig discount;
  const _FareText({required this.fare, required this.discount});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasDiscount = discount.appliesTo(fare);

    if (!hasDiscount) {
      return Text(
        "${fare.formatWithThousands()} so'm",
        textAlign: TextAlign.end,
        style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
      );
    }

    final discountedFare = discount.discountedFare(fare);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "${fare.formatWithThousands()} so'm",
          style: textTheme.titleMedium?.copyWith(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.lineThrough,
            decorationColor: Colors.grey.shade400,
            decorationThickness: 2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "${discountedFare.formatWithThousands()} so'm",
          style: textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
