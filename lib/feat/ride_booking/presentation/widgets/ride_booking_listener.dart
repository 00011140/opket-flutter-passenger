import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/active_ride/index.dart';
import 'package:opket/feat/active_ride/services/active_ride_cache_service.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_booking_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_map_cubit.dart';

class RideBookingListener extends StatelessWidget {
  const RideBookingListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RideBookingCubit, RideBookingState>(
      listenWhen: (prev, curr) => prev != curr,
      listener: (context, state) {
        if (state is RequestRideLoading) {
        } else if (state is RequestRideSuccess) {
          context.read<ActiveRideCubit>().onRideCreated(state.rideId);
        } else if (state is CancelRideSuccess) {
          context.read<RideMapCubit>().onRideCancelled();
          context.read<ActiveRideCubit>().reset();
          ActiveRideCacheService.clearRideState();
        } else if (state is CancelRideError) {
          print(state.message);
        }
      },
      child: SizedBox.shrink(),
    );
  }
}
