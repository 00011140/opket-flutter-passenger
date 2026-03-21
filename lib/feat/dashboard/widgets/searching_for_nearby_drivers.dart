import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:opket/components/app_container.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/cubit/cool_down_cubit.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/services/audio_service.dart';
import 'package:opket/services/cooldown_service.dart';

class SearchingForNearbyDrivers extends StatefulWidget {
  const SearchingForNearbyDrivers({super.key});

  @override
  State<SearchingForNearbyDrivers> createState() =>
      _SearchingForNearbyDriversState();
}

class _SearchingForNearbyDriversState extends State<SearchingForNearbyDrivers> {
  int _secondsRemaining = 0;
  Timer? _timer;

  final CooldownStorageService _cooldownService = CooldownStorageService();

  @override
  void initState() {
    super.initState();
    _onRideRequestSuccess();
    _loadCooldown();
  }

  /// Load cooldown from storage when the widget initializes
  void _loadCooldown() async {
    int remaining = await _cooldownService.getRemainingCooldown();
    if (remaining > 0) {
      startCooldown(remaining);
      return;
    }
  }

  /// Starts the cooldown timer and optionally saves it to storage
  void startCooldown(int seconds) {
    context.read<CoolDownCubit>().active();

    setState(() {
      _secondsRemaining = seconds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
        });
        context.read<CoolDownCubit>().inactive();
      } else {
        setState(() {
          _secondsRemaining -= 1;
        });
      }
    });
  }

  /// Call this after ride request succeeds
  void _onRideRequestSuccess() async {
    const cooldownDuration = 60; // seconds
    await _cooldownService.saveCooldown(cooldownDuration);
    startCooldown(cooldownDuration);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: const [BoxShadow(blurRadius: 15, color: Colors.black12)],
      ),
      child: AppContainer(
        child: BlocConsumer<RideCubit, RideState>(
          listener: (context, state) {
            if (state is CancelRideSuccess) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            final isLoading = state is CancelRideLoading;

            return BlocBuilder<CoolDownCubit, CoolDownState>(
              builder: (context, coolDownState) {
                // if (coolDownState is CoolDownInActive) return Container();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/Taxi.json', width: 90),
                    Text(
                      "Sizga yaqin haydovchilarni qidiryapmiz",
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppSpacing.md),
                    AppIconButtonRectangle(
                      icon: Icons.close,
                      text: "Bekor qilish",
                      isLoading: isLoading,
                      onPressed: _cancelRide,
                    ),
                    SizedBox(height: bottom),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _cancelRide() {
    AudioService().stopSound();
    final rideId = context.read<CurrentRideCubit>().state.rideId;
    context.read<RideCubit>().cancelRide(rideId);
  }
}
