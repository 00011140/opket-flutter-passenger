import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';

class CooldownInfoText extends StatelessWidget {
  const CooldownInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentRideCubit, CurrentRideState>(
      builder: (context, state) {
        if (state.rideId == null) return Container();

        return Padding(
          padding: EdgeInsetsGeometry.only(top: 8),
          child: Text(
            "1 daqiqadan so'ng haydovchi topilmasa, qayta urinib ko'ring",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        );
      },
    );
  }
}
