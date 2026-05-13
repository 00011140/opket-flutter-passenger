import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/ride_booking/domain/usecases/cancel_ride.dart';
import 'package:opket/feat/ride_booking/domain/usecases/request_ride.dart';

part 'ride_booking_state.dart';

class RideBookingCubit extends Cubit<RideBookingState> {
  final RequestRide requestRideUsecase;
  final CancelRide cancelRideUsecase;

  RideBookingCubit({
    required this.requestRideUsecase,
    required this.cancelRideUsecase,
  }) : super(RideInitial());

  void requestRide(RequestRideParams params) async {
    try {
      emit(RequestRideLoading());
      final result = await requestRideUsecase(params);

      emit(
        result.fold(
          (l) => RequestRideError(message: l.message),
          (r) => RequestRideSuccess(
            rideId: r.rideId,
            searchDurationMs: r.searchDurationMs,
          ),
        ),
      );
    } catch (e) {
      emit(RequestRideError(message: e.toString()));
    }
  }

  void cancelRide(String rideId, {String? reasonKey}) async {
    try {
      emit(CancelRideLoading());
      final result = await cancelRideUsecase(
        CancelRideParams(rideId: rideId, reasonKey: reasonKey),
      );

      emit(
        result.fold(
          (l) => CancelRideError(message: l.message),
          (r) => CancelRideSuccess(),
        ),
      );
    } catch (e) {
      emit(CancelRideError(message: e.toString()));
    }
  }

  void reset() {
    emit(RideInitial());
  }
}
