import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/services/location_service.dart';
import 'package:opket/core/services/referral_location_service.dart';
import 'package:opket/core/widgets/allow_location_dialog.dart';
import 'package:opket/feat/active_ride/domain/models/route_update.dart';
import 'package:opket/feat/active_ride/index.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_cubit.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_state.dart';
import 'package:opket/feat/dashboard/cubit/location_cubit.dart';
import 'package:opket/feat/dashboard/widgets/turnon_notification_dialog.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_map_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/widgets/ride_completed_sheet.dart';
import 'package:opket/feat/ride_options/domain/entities/ride_option.dart';
import 'package:opket/feat/ride_options/index.dart';

class RideEffectListener extends StatelessWidget {
  const RideEffectListener({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ActiveRideCubit, ActiveRideState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.candidateDrivers != curr.candidateDrivers ||
              prev.routeUpdate != curr.routeUpdate,
          listener: (context, state) {
            final mapCubit = context.read<RideMapCubit>();

            if (!mapCubit.state.isReady) return; // 👈 guard

            _handleCandidateDrivers(state, mapCubit);
            _handleRouteUpdate(state, mapCubit);
          },
          child: const SizedBox.shrink(),
        ),
        BlocListener<ActiveRideCubit, ActiveRideState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            final mapCubit = context.read<RideMapCubit>();
            _handleRideAccepted(state, mapCubit);
            if (state.status == RideStatus.accepted) {
              _showNotificationDialogIfNeeded(context);
            }
          },
        ),

        BlocListener<ActiveRideCubit, ActiveRideState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            final mapCubit = context.read<RideMapCubit>();
            _handleRideComepleted(state, mapCubit);
          },
        ),

        BlocListener<ActiveRideCubit, ActiveRideState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              curr.status == RideStatus.completed,
          listener: (context, state) {
            _showRideCompletedSheet(context, state);
          },
        ),
        BlocListener<ActiveRideCubit, ActiveRideState>(
          listenWhen: (prev, curr) => prev.location != curr.location,

          listener: (context, state) {
            if (state.location != null && state.pickupLocation != null) {
              context.read<RideMapCubit>().animateDriverTo(
                state.location!,
                state.pickupLocation!,
              );
            }
          },
        ),
        BlocListener<RideMapCubit, RideMapState>(
          listenWhen: (prev, curr) => prev.isReady != curr.isReady,
          listener: (context, mapState) {
            if (!mapState.isReady) return;

            final rideState = context.read<ActiveRideCubit>().state;
            final mapCubit = context.read<RideMapCubit>();

            if (rideState.status == RideStatus.searching &&
                rideState.candidateDrivers != null) {
              mapCubit.showCandidateDrivers(rideState.candidateDrivers!);
            }
          },
        ),
        BlocListener<OtpCubit, OtpState>(
          listener: (context, state) {
            final step = state.step;
            if (step == OtpStep.registered) {
              _showLocationDialog(context);
            }
          },
        ),
        BlocListener<LocationCubit, LocationState>(
          listener: (context, state) {
            print(state);
            if (state is LocationPermissionGranted) {
              context.read<RideMapCubit>().init();
              _verifyReferralLocation();
            }
          },
        ),
      ],
      child: SizedBox.shrink(),
    );
  }

  void _showRideCompletedSheet(BuildContext context, ActiveRideState state) {
    final selectedIds = context.read<SelectedRideOptionsCubit>().state;
    final optionsState = context.read<RideOptionsCubit>().state;
    final allOptions =
        optionsState is RideOptionsSuccess ? optionsState.options : <RideOption>[];
    final selectedOptions =
        allOptions.where((o) => selectedIds.contains(o.id)).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => RideCompletedSheet(
        fare: state.progress.fare,
        distance: state.progress.distance,
        driverName: state.driver?.name,
        selectedOptions: selectedOptions,
        onSubmit: (rating, comment) async {
          final rideId = state.rideId;
          if (rideId != null && context.mounted) {
            await context.read<ActiveRideCubit>().rateRide(
              rideId: rideId,
              rating: rating,
              comment: comment,
            );
          }
          if (context.mounted) {
            Navigator.of(context).pop();
            _resetAfterCompletion(context);
          }
        },
        onClose: () {
          Navigator.of(context).pop();
          _resetAfterCompletion(context);
        },
      ),
    );
  }

  void _resetAfterCompletion(BuildContext context) {
    context.read<ActiveRideCubit>().onRideSummaryDismissed();
    context.read<SelectedRideOptionsCubit>().reset();
  }

  Future<void> _verifyReferralLocation() async {
    final position = await LocationService.getCurrentPosition();
    if (position == null) return;
    ReferralLocationService.verifyLocation(position.latitude, position.longitude);
  }

  void _showNotificationDialogIfNeeded(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      final allowed = await AwesomeNotifications().isNotificationAllowed();
      if (allowed) return;
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) => const TurnonNotificationDialog(),
      );
    });
  }

  void _showLocationDialog(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () async {
      final isPremissionGranted = await LocationService.isPermissionGranted();
      if (isPremissionGranted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AllowLocationDialog();
        },
      );
    });
  }

  void _handleCandidateDrivers(ActiveRideState state, RideMapCubit mapCubit) {
    final detected =
        state.status == RideStatus.searching && state.candidateDrivers != null;

    if (detected) {
      mapCubit.showCandidateDrivers(state.candidateDrivers!);
    }
  }

  void _handleRouteUpdate(ActiveRideState state, RideMapCubit mapCubit) {
    final routeUpdate = state.routeUpdate;

    final accepted = state.status == RideStatus.accepted && routeUpdate != null;

    if (accepted) {
      mapCubit.startAnimation(RouteUpdate.toLatLngList(routeUpdate.points));
    }
  }

  void _handleDriverLocation(ActiveRideState state, RideMapCubit mapCubit) {
    if (state.location != null && state.pickupLocation != null) {
      mapCubit.animateDriverTo(state.location!, state.pickupLocation!);
    }
  }

  void _handleRideComepleted(ActiveRideState state, RideMapCubit mapCubit) {
    if (state.status == RideStatus.idle ||
        state.status == RideStatus.completed) {
      mapCubit.onRideCancelled();
    }
  }

  Future<void> _handleRideAccepted(
    ActiveRideState state,
    RideMapCubit mapCubit,
  ) async {
    final pickupLocation = state.pickupLocation;
    final driverLocation = state.location;
    final accepted =
        state.status == RideStatus.accepted &&
        driverLocation != null &&
        pickupLocation != null;

    if (accepted) {
      await mapCubit.showAcceptedDriver(
        pickupLocation: pickupLocation,
        driverLocation: driverLocation,
      );
    }
  }

  void _handleCurrentRide(ActiveRideState state, BuildContext context) {
    final detected =
        state.status == RideStatus.searching && state.rideId != null;

    if (detected) {
      context.read<GetCurrentRideCubit>().getCurrentRide(state.rideId!);
    }
  }
}
