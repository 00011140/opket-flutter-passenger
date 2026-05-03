import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/active_ride/index.dart';

class GetCurrentRideListener extends StatelessWidget {
  const GetCurrentRideListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetCurrentRideCubit, GetCurrentRideState>(
      listenWhen: (prev, curr) => prev != curr,
      listener: (context, state) {
        if (state is GetCurrentRideSuccess) {
          final ride = state.ride;

          context.read<ActiveRideCubit>().handleRideAccepted(
            driver: ride.driver,
            location: ride.driverLocation,
          );
        } else if (state is GetCurrentRideError) {
          print("****************");
          print(state.message);
        }
      },
      child: SizedBox.shrink(),
    );
  }
}
