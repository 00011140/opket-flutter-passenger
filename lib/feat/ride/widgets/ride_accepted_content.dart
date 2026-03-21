import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:opket/feat/ride/widgets/cancel_ride_button.dart';
import 'package:opket/feat/ride/widgets/cancel_ride_confirmation.dart';
import 'package:opket/feat/ride/widgets/car_plate.dart';
import 'package:opket/models/ride_model.dart';
import 'package:opket/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class RideAcceptedContent extends StatefulWidget {
  final DriverModel driver;

  const RideAcceptedContent({super.key, required this.driver});

  @override
  State<RideAcceptedContent> createState() => _RideAcceptedContentState();
}

class _RideAcceptedContentState extends State<RideAcceptedContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        16,
      ).copyWith(bottom: MediaQuery.of(context).viewPadding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          /// Driver Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "${widget.driver.carColor} ${widget.driver.carModel}",

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              IconButton.filled(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.all(10),
                  backgroundColor: Color.fromARGB(255, 19, 202, 65),
                ),
                onPressed: _callDriver,
                icon: Icon(Icons.phone, size: 25),
              ),
            ],
          ),
          Align(
            alignment: AlignmentGeometry.centerLeft,
            child: Text(
              widget.driver.driverName,
              style: const TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          CarPlate(carNumber: widget.driver.carNumber),
          const SizedBox(height: 20),

          /// Car Info Card
          const SizedBox(height: 16),
          CancelRideButton(),
          BlocListener<CurrentRideCubit, CurrentRideState>(
            listener: (_, state) {
              if (state.status == RideStatus.idle) {
                _clearRide();
              }
            },
            child: Container(),
          ),
        ],
      ),
    );
  }

  void _clearRide() {
    Navigator.pop(context);
    context.read<CurrentRideCubit>().reset();
  }

  void _callDriver() async {
    final phone = widget.driver.phone.addUzbCode();
    final Uri uri = Uri.parse('tel:$phone');

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
