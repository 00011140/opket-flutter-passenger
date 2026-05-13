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
          onPressed: () => _onPressed(context),
          isLoading: state is CancelRideLoading,
        );
      },
    );
  }

  /// After the driver has already accepted, the cancellation has a real cost
  /// for them, so we ask for a reason before submitting. The user can still
  /// dismiss the sheet (X icon) and the cancel goes through without a reason.
  Future<void> _onPressed(BuildContext context) async {
    final result = await showCancelReasonSheet(context);
    if (result == null || !result.confirmed) return;
    if (!context.mounted) return;

    final rideId = context.read<ActiveRideCubit>().state.rideId;
    if (rideId == null) return;

    context
        .read<RideBookingCubit>()
        .cancelRide(rideId, reasonKey: result.reasonKey);
  }
}
