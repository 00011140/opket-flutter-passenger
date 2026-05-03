part of '../index.dart';

class RideBookingOverlay extends StatelessWidget {
  const RideBookingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveRideCubit, ActiveRideState>(
      builder: (context, state) {
        final showOverlay = state.status == RideStatus.searching;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween(begin: 1.05, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          child: showOverlay
              ? const AppOverlay(key: ValueKey("overlay"))
              : const SizedBox.shrink(key: ValueKey("empty")),
        );
      },
    );
  }
}
