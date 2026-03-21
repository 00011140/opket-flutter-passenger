import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/OtpInputField.dart';
import 'package:opket/cubit/cool_down_cubit.dart';
import 'package:opket/cubit/create_user_cubit.dart';
import 'package:opket/cubit/otp_sms_cubit.dart';
import 'package:opket/cubit/otp_state.dart';
import 'package:opket/cubit/premium_taxi_cubit.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';
import 'package:opket/feat/dashboard/cubit/location_cubit.dart';
import 'package:opket/feat/luggage/cubit/luggage_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:opket/feat/ride/cubit/driver_location_cubit.dart';
import 'package:opket/models/driver_location.dart';

class DashboardBlocListeners extends StatelessWidget {
  const DashboardBlocListeners({
    super.key,
    required this.onDriverLocation,
    required this.onUserCreated,
    required this.onLuggageRequested,
    required this.onRideAccepted,
    required this.onRideRequested,
    required this.onLocationEnabled,
    required this.clearRide,
  });

  final void Function(DriverLocation) onDriverLocation;
  final VoidCallback onUserCreated;
  final void Function(DriverLocation location) onRideAccepted;
  final VoidCallback onRideRequested;
  final VoidCallback onLocationEnabled;

  final VoidCallback clearRide;
  final void Function(int charge, String driverId) onLuggageRequested;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DriverLocationCubit, DriverLocationState>(
          listener: (_, state) {
            if (state is DriverLocationUpdate) {
              onDriverLocation(state.location);
            }
          },
        ),
        BlocListener<CreateUserCubit, CreateUserState>(
          listener: (_, state) {
            if (state is CreateUserSuccess) {
              context.read<BalanceCubit>().loadBalance();
            }
          },
        ),
        BlocListener<CreateUserCubit, CreateUserState>(
          listener: (context, state) {
            if (state is CreateUserSuccess) {
              onUserCreated();
            }
          },
          child: Container(),
        ),
        BlocListener<LuggageCubit, LuggageState>(
          listener: (_, state) {
            if (state is DriverRequestingLuggage) {
              onLuggageRequested(state.luggageCharge, state.driverId);
            }
          },
        ),
        BlocListener<CurrentRideCubit, CurrentRideState>(
          listener: (_, state) {
            if (state.status == RideStatus.accepted) {
              context.read<CoolDownCubit>().inactive();
              context.read<PremiumTaxiCubit>().reset();
              onRideAccepted(state.location!);
            } else if (state.status == RideStatus.started) {
              clearRide();
            } else if (state.status == RideStatus.idle) {
              clearRide();
            }
          },
        ),
        BlocListener<RideCubit, RideState>(
          listener: (_, state) {
            if (state is RideRequestSuccess) {
              onRideRequested();
            } else if (state is CancelRideSuccess) {
              clearRide();
              // context.read<SpamGuardCubit>().onUserCancelledRide();
            }
          },
        ),
        BlocListener<LocationCubit, bool>(
          listener: (_, state) {
            onLocationEnabled();
          },
        ),
      ],
      child: const SizedBox.shrink(),
    );
  }
}
