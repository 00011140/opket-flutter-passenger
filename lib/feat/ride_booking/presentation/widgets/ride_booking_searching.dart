part of '../index.dart';

class RideBookingSearching extends StatelessWidget {
  const RideBookingSearching({super.key, required this.candidateDrivers});
  final List<DriverLocation> candidateDrivers;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.lg),
      child: AppCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.black,
              highlightColor: Colors.white,
              child: Text(
                candidateDrivers.isEmpty
                    ? "Yaqin atrofdagi \nhaydovchilarni qidiryapmiz"
                    : "${candidateDrivers.length} ta haydovchi topildi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  // fontFamily: 'WorkSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // SizedBox(height: AppSpacing.sm),
            // Shimmer.fromColors(
            //   baseColor: Colors.grey.shade400,
            //   highlightColor: Colors.white,
            //   child: Text(
            //     candidateDrivers.isEmpty
            //         ? "Sizga yaqin atrofda yurgan haydovchilarni qidiryapmiz"
            //         : "Haydovchilarga buyurtma taklif qilinmoqda iltimos broz kutib turing",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 14),
            //   ),
            // ),
            SizedBox(height: AppSpacing.md),
            BlocBuilder<RideBookingCubit, RideBookingState>(
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
    final rideId = context.read<ActiveRideCubit>().state.rideId;
    if (rideId != null) {
      context.read<RideBookingCubit>().cancelRide(rideId);
    }
  }
}
