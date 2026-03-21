import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'dart:math' as math;

import 'package:opket/components/app_card.dart';
import 'package:opket/components/app_container.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/dashboard/cubit/call_cubit.dart';
import 'package:opket/feat/dashboard/cubit/location_confirmation_cubit.dart';

class LocationConfirmation extends StatefulWidget {
  final bool showLocationHints;
  final VoidCallback onPressNo;

  const LocationConfirmation({
    super.key,
    required this.showLocationHints,
    required this.onPressNo,
  });

  @override
  State<LocationConfirmation> createState() => _LocationConfirmationState();
}

class _LocationConfirmationState extends State<LocationConfirmation>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    context.read<LocationConfirmationCubit>().setData(
      shakeController: _shakeController,
    );

    // Shake immediately if it starts visible
    if (widget.showLocationHints) {
      _shakeController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant LocationConfirmation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger shake ONLY when false -> true
    if (!oldWidget.showLocationHints && widget.showLocationHints) {
      _shakeController
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 45, color: Colors.red),
            SizedBox(height: AppSpacing.sm),
            const Text(
              "Belgilangan manzil siz turgan joylashuv emas, TAXI shu yerga kelsinmi ?",
              style: TextStyle(
                // fontFamily: 'WorkSans',
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppIconButtonRectangle(
                    text: "YO'Q",
                    onPressed: () async {
                      final map = context
                          .read<LocationConfirmationCubit>()
                          .state
                          .map;
                      await map?.recenterToUser(context);
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.grey.shade200,
                    textColor: Colors.black,
                    height: 55,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppIconButtonRectangle(
                    text: "HA",
                    onPressed: () {
                      Navigator.pop(context);
                      _requestRide();
                    },
                    backgroundColor: const Color(0xFFFFE711),
                    textColor: Colors.black,
                    height: 55,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _requestRide() {
    context.read<CallCubit>().setCallingPageStatus(true);
    context.read<RideCubit>().requestRide();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
}
