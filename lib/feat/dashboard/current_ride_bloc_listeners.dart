import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/dashboard/widgets/searching_for_nearby_drivers.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:opket/feat/ride/widgets/ride_accepted_content.dart';
import 'package:opket/models/ride_model.dart';
import 'package:opket/feat/dashboard/widgets/turnon_notification_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class CurrentRideBlocListeners extends StatelessWidget {
  const CurrentRideBlocListeners({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CurrentRideCubit, CurrentRideState>(
          listener: (_, state) {
            final status = state.status;

            print("📤 📤📤📤📤E: $status");
            if (status == RideStatus.pending) {
              _showLookingForDriversSheet(context);
            } else if (status == RideStatus.accepted) {
              _showRideAcceptedSheet(context, state.driver!);
              _showNotificationsDialog(context);
            }
          },
        ),
      ],
      child: Container(),
    );
  }

  void _showLookingForDriversSheet(BuildContext context) {
    Scaffold.of(context).showBottomSheet(
      (context) {
        return SearchingForNearbyDrivers();
      },
      backgroundColor: Colors.white,
      enableDrag: false,
      showDragHandle: false,
    );
  }

  void _showRideAcceptedSheet(BuildContext context, DriverModel driver) {
    Scaffold.of(context).showBottomSheet(
      (context) {
        return RideAcceptedContent(driver: driver);
      },
      backgroundColor: Colors.white,
      enableDrag: false,
      showDragHandle: false,
    );
  }

  void _showNotificationsDialog(BuildContext context) async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    Future.delayed(Duration(seconds: 4), () {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) {
            return TurnonNotificationDialog();
          },
        );
      }
    });
  }
}
