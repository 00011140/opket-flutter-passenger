import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/constants/app_icons.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/dashboard/cubit/call_cubit.dart';

class EndCallbutton extends StatelessWidget {
  const EndCallbutton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            context.read<CallCubit>().setCallingPageStatus(false);
            context.read<RideCubit>().endCall();
          },
          child: Center(
            child: Icon(AppIcons.deliveryMan, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }
}
