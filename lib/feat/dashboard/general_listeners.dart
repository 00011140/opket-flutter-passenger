import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/dashboard/cubit/location_confirmation_cubit.dart';

class GeneralListeners extends StatelessWidget {
  const GeneralListeners({super.key, required this.onOutSideOfUserLocation});
  final VoidCallback onOutSideOfUserLocation;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationConfirmationCubit, LocationConfirmtionState>(
      listener: (_, state) {
        if (!state.isUserLocation) {
          onOutSideOfUserLocation();
        }
      },
      child: Container(),
    );
  }
}
