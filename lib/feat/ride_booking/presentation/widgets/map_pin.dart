part of '../index.dart';

class MapPin extends StatelessWidget {
  const MapPin({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((ActiveRideCubit c) => c.state.status);

    final isUserLocation = context.select(
      (RideMapCubit c) => c.state.isUserLocation,
    );

    final controller = context.read<RideMapCubit>().pin;

    print("STATUS: $status");

    return Transform.translate(
      offset: const Offset(0, -60),
      child: status == RideStatus.idle
          ? AnimatedMapPinTaxi(
              isUserLocation: isUserLocation,
              controller: controller,
            )
          : status == RideStatus.searching
          ? const SearchingDriversPin()
          : const SizedBox.shrink(),
    );
  }
}
