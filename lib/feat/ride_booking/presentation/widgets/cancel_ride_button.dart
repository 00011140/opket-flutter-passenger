part of '../index.dart';

class CancelRideButton extends StatelessWidget {
  const CancelRideButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideBookingCubit, RideBookingState>(
      builder: (context, state) {
        return AppIconButtonRectangle(
          text: "Bekor Qilish",
          backgroundColor: Colors.grey.shade200,
          icon: Icons.remove_circle_rounded,
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
    final rideId = context.read<ActiveRideCubit>().state.rideId;

    if (rideId != null) {
      context.read<RideBookingCubit>().cancelRide(rideId);
    }
  }
}
