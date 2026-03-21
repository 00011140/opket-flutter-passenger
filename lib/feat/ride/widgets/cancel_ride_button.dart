import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/widgets/cancel_ride_confirmation.dart';

class CancelRideButton extends StatelessWidget {
  const CancelRideButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        return AppIconButtonRectangle(
          text: "Bekor Qilish",
          icon: Icons.close,
          onPressed: () => _cancelRideConfirmation(context),
          isLoading: state is CancelRideLoading,
        );
      },
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
    print(rideId);
    if (rideId != null) {
      context.read<RideCubit>().cancelRide(rideId);
    }
  }
}
