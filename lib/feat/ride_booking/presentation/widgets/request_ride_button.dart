part of '../index.dart';

class RequestRideButton extends StatefulWidget {
  const RequestRideButton({super.key});

  @override
  State<RequestRideButton> createState() => _RequestRideButtonState();
}

class _RequestRideButtonState extends State<RequestRideButton> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RideValidationCubit, RideValidationState>(
      listener: _listenRideBookingCubit,
      child: BlocBuilder<RideBookingCubit, RideBookingState>(
        builder: (context, state) {
          final isLoading = state is RequestRideLoading;
          return AppIconButtonRectangle(
            size: AppButtonSize.large,
            onPressed: onCallPress,
            isLoading: isLoading,
            text: "Taxi Chaqirish",
            textColor: Colors.black,
            backgroundColor: const Color(0xFFFFE711),
          );
        },
      ),
    );
  }

  void onCallPress() async {
    final mapState = context.read<RideMapCubit>().state;

    context.read<RideValidationCubit>().validateRequest(
      mapState.isUserLocation,
    );

    // context.read<RideMapCubit>().setUserMarker();
  }

  void _listenRideBookingCubit(
    BuildContext context,
    RideValidationState state,
  ) {
    if (state is NoInternet) {
      ToastService.shake();
    } else if (state is NotAuthenticated) {
      showModalBottomSheet(
        useSafeArea: true,
        isDismissible: false,
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black54,
        builder: (_) {
          return AuthPage();
        },
      );
    } else if (state is LocationServicesNotEnabled) {
      _showEnableLocationServicesDialog();
    } else if (state is LocationPermissionDenied) {
      _showLocationDialog();
    } else if (state is LocationPermissionDeniedForever) {
      _showLocationDialog(true);
    } else if (state is NotCurrentUserLocation) {
      _showLocationConfirmtionSheet();
    } else if (state is RideValidationSuccess) {
      _requestRide();
    }
  }

  void _showLocationConfirmtionSheet() {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return LocationConfirmation(
          showLocationHints: false,
          onPressNo: () {
            context.read<RideMapCubit>().recenter();
            context.read<RideMapCubit>().clearMarkers();
          },
          onPressYes: _requestRide,
        );
      },
    );
  }

  void _showLocationDialog([bool deniedForever = false]) {
    showDialog(
      context: context,
      builder: (context) {
        return AllowLocationDialog(deniedForever: deniedForever);
      },
    );
  }

  void _requestRide() {
    final mapCubit = context.read<RideMapCubit>();
    final optionsCubit = context.read<SelectedRideOptionsCubit>();
    final location = mapCubit.state.selectedLocation;
    final options = optionsCubit.state;

    if (location != null) {
      final params = RequestRideParams(location: location, options: options);
      context.read<RideBookingCubit>().requestRide(params);
      context.read<ActiveRideCubit>().setPickupLocation(location);
    }
  }

  void _showEnableLocationServicesDialog() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return EnableLocationServicesDialog();
      },
    );
  }
}
