import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/app_card.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/widgets/cancel_ride_confirmation.dart';

class SearchingDrivers extends StatelessWidget {
  const SearchingDrivers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.lg),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Yaqin atrofdagi haydovchilarni qidiryapmiz",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            BlocBuilder<RideCubit, RideState>(
              builder: (context, state) {
                return AppIconButtonRectangle(
                  width: AppButtonWidth.wrap,
                  onPressed: () => _cancelRideConfirmation(context),
                  backgroundColor: Colors.grey.shade200,
                  icon: Icons.remove_circle_rounded,
                  text: "Bekor qilish",
                  isLoading: state is CancelRideLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _cancelRideConfirmation(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return CancelRideConfirmation(
          onConfirmed: () {
            _cancelRide(context);
          },
        );
      },
    );
  }

  void _cancelRide(BuildContext context) {
    final rideId = context.read<CurrentRideCubit>().state.rideId;
    if (rideId != null) {
      context.read<RideCubit>().cancelRide(rideId);
    }
  }
}
