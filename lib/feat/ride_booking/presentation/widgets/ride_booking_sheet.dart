part of '../index.dart';

class RideBookingSheet extends StatelessWidget {
  const RideBookingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveRideCubit, ActiveRideState>(
      builder: (context, state) {
        return Stack(
          children: [
            _AnimatedSheet(
              visible: state.status == RideStatus.searching,
              child: RideBookingSearching(
                candidateDrivers: state.candidateDrivers ?? [],
              ),
            ),

            _AnimatedSheet(
              visible:
                  state.status == RideStatus.accepted ||
                  state.status == RideStatus.started,
              child: state.driver != null
                  ? RideBookingAccepted(driver: state.driver!)
                  : const SizedBox(),
            ),

            // Idle usually shouldn't animate in from bottom,
            // so keep it separate unless you want it animated too
            if (state.status == RideStatus.idle)
              RideBookingSheetIdle(
                onRecenter: () {
                  context.read<RideMapCubit>().recenter();
                },
              ),
          ],
        );
      },
    );
  }
}

class _AnimatedSheet extends StatelessWidget {
  final bool visible;
  final Widget child;

  const _AnimatedSheet({required this.visible, required this.child});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      bottom: visible ? bottomPadding : -300,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: visible ? 1 : 0,
        child: child,
      ),
    );
  }
}
