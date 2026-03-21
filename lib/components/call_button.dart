import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/components/authentication_wrapper.dart';
import 'package:opket/components/enable_location_services_dialog.dart';
import 'package:opket/components/spam_guard_content.dart';
import 'package:opket/components/toast_service.dart';
import 'package:opket/cubit/premium_taxi_cubit.dart';
import 'package:opket/cubit/premium_taxi_state.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/dashboard/cubit/call_cubit.dart';
import 'package:opket/feat/dashboard/cubit/location_confirmation_cubit.dart';
import 'package:opket/feat/dashboard/cubit/location_cubit.dart';
import 'package:opket/feat/dashboard/widgets/location_confirmation.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:opket/feat/ride/cubit/spam_guard_cubit.dart';
import 'package:opket/feat/ride/cubit/spam_guard_state.dart';
import 'package:opket/services/audio_service.dart';
import 'package:opket/services/connectivity_service.dart';
import 'package:opket/services/location_service.dart';
import 'package:opket/services/user_storage.dart';
import 'package:opket/utils/show_bottom_sheet.dart';

class CallButton extends StatefulWidget {
  const CallButton({super.key});

  @override
  State<CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<CallButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpamGuardCubit, SpamGuardState>(
      builder: (context, spamGuardState) {
        // print(spamGuardState.blocked);

        return BlocBuilder<PremiumTaxiCubit, PremiumTaxiState>(
          builder: (context, premiumState) {
            return BlocBuilder<CurrentRideCubit, CurrentRideState>(
              builder: (context, currentRideState) {
                final pending = currentRideState.status == RideStatus.pending;

                return BlocConsumer<RideCubit, RideState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    final isLoading = state is RideRequestLoading;
                    return AppIconButtonRectangle(
                      size: AppButtonSize.large,
                      onPressed: onCallPress,
                      isLoading: isLoading,
                      text: "Taxi Chaqirish",
                      textColor: Colors.black,
                      backgroundColor: const Color(0xFFFFE711),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void hasActiveRideRequest() {
    AudioService().playSound("has_current_ride.m4a");
  }

  void onCallPress() async {
    final validated = await _validate();
    if (!validated) return;

    _requestRide();
  }

  Future<bool> _validate() async {
    // Check if user is not blocked
    final spamGuardState = context.read<SpamGuardCubit>().state;

    if (spamGuardState.blocked) {
      _showBlockedDialog();
      return false;
    }

    // Check INTERNET connection
    final hasInternet = ConnectivityService().hasInternet;
    if (!hasInternet) {
      ToastService.shake();
      return false;
    }

    final isPhoneShared = await UserStorage().isPhoneShared();

    // Check if user has entered their phone number
    if (!isPhoneShared) {
      showAppModelBottomSheet(context, const AuthenticationWrapper());
      return false;
    }

    // Check if location Services enabled
    final isLocationEnabled = await LocationService.isLocationEnabled();

    if (!isLocationEnabled) {
      _showEnableLocationServicesDialog();
      return false;
    }

    final permissionResult = await LocationService.requestPermission();

    // ✅ only update cubit if permission dialog was shown
    if (permissionResult.asked) {
      context.read<LocationCubit>().setData(permissionResult.granted);
    }

    if (!permissionResult.granted) return false;

    // Confirm user seleced location other than his current location
    final locationState = context.read<LocationConfirmationCubit>().state;

    if (!locationState.isUserLocation) {
      // locationState.shakeController
      //   ?..reset()
      //   ..forward();

      _showLocationConfirmtionSheet();
      return false;
    }

    return true;
  }

  void _showLocationConfirmtionSheet() {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return LocationConfirmation(showLocationHints: false, onPressNo: () {});
      },
    );
  }

  void _requestRide() {
    context.read<CallCubit>().setCallingPageStatus(true);
    context.read<RideCubit>().requestRide();
  }

  void _showBlockedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SpamGuardContent();
      },
    );
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
