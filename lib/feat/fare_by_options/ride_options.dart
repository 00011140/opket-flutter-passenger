import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/constants/app_icons.dart';
import 'package:opket/feat/fare_by_options/fare_config_page.dart';
import 'package:opket/feat/fare_by_options/fare_cubit.dart';

class RideOptions extends StatefulWidget {
  const RideOptions({super.key});

  @override
  State<RideOptions> createState() => _RideOptionsState();
}

class _RideOptionsState extends State<RideOptions> {
  @override
  void initState() {
    context.read<FareCubit>().loadFareConfig();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FareCubit, FareState>(
      builder: (context, state) {
        if (state.loading && state.data == null) {
          return IconButton(
            onPressed: _showRideOptions,
            icon: Icon(AppIcons.tune, size: 30),
          );
        }

        if (state.data == null) {
          return IconButton(
            onPressed: _showRideOptions,
            icon: Icon(AppIcons.tune, size: 30),
          );
        }

        final fare = state.selectedFare!;
        final enabledServices = fare.enabledServices;
        return Stack(
          children: [
            IconButton.filled(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: _showRideOptions,
              icon: Icon(AppIcons.tune, size: 30, color: Colors.black),
            ),
            if (enabledServices.isNotEmpty)
              Positioned(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2CCC31),
                  ),
                  child: Center(
                    child: Text(
                      enabledServices.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showRideOptions() {
    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
      builder: (_) {
        return const FareConfigPage();
      },
    );
  }
}
