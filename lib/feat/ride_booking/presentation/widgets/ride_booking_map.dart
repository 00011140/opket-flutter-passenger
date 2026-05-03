part of '../index.dart';

class RideBookingMap extends StatelessWidget {
  const RideBookingMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideMapCubit, RideMapState>(
      builder: (context, state) {
        final cubit = context.read<RideMapCubit>();
        final rideState = context.read<ActiveRideCubit>().state;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween(begin: 1.05, end: 1.0).animate(animation),
                child: child,
              ),
            );
          },
          child: state.isLoading || state.currentLocation == null
              ? const MapGridLoader(key: ValueKey("loader"))
              : GoogleMap(
                  padding: EdgeInsets.only(bottom: 40),
                  key: const ValueKey("map"),
                  cloudMapId: "bbbde3d92482b64f7d20bfe3",
                  compassEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: state.currentLocation!,
                    zoom: 18,
                  ),
                  markers: state.markers,
                  onMapCreated: (mapController) {
                    cubit.map.onMapCreated(mapController);
                    context.read<ActiveRideCubit>().init();
                  },
                  onCameraMove: (p) {
                    if (rideState.status != RideStatus.idle) {
                      return;
                    }
                    cubit.onCameraMove(p.target);
                  },
                  onCameraMoveStarted: cubit.onCameraMoveStarted,
                  onCameraIdle: cubit.onCameraIdle,
                  polylines: state.animatedRoute.isEmpty
                      ? {}
                      : {
                          Polyline(
                            polylineId: const PolylineId("route"),
                            points: state.animatedRoute,
                            color: const Color.fromARGB(255, 0, 207, 7),
                            width: 4,
                          ),
                        },
                ),
        );
      },
    );
  }
}
