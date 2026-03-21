import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/dashboard/widgets/add_luggage.dart';

import 'package:opket/feat/fare_by_options/ride_options.dart';
import 'package:opket/feat/feature_flag/feature_flag_cubit.dart';

import 'premium_taxi.dart';

class CallTaxiHeader extends StatefulWidget {
  const CallTaxiHeader({super.key});

  @override
  State<CallTaxiHeader> createState() => _CallTaxiHeaderState();
}

class _CallTaxiHeaderState extends State<CallTaxiHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<FeatureFlagCubit, FeatureFlagState>(
          builder: (context, state) {
            if (state.isLuggageEnabled) {
              return AddLuggage();
            } else {
              return PremiumTaxi();
            }
          },
        ),

        RideOptions(),
      ],
    );
  }
}
