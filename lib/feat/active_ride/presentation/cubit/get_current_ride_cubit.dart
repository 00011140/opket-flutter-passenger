part of '../../index.dart';

class GetCurrentRideCubit extends Cubit<GetCurrentRideState> {
  final GetCurrentRide getCurrentRideUsecase;
  GetCurrentRideCubit(this.getCurrentRideUsecase)
    : super(GetCurrentRideInitial());

  void getCurrentRide(String rideId) async {
    try {
      final result = await getCurrentRideUsecase(
        GetCurrentRideParams(rideId: rideId),
      );

      emit(
        result.fold(
          (l) => GetCurrentRideError(message: l.message),
          (r) => GetCurrentRideSuccess(ride: r),
        ),
      );
    } catch (e) {
      emit(GetCurrentRideError(message: e.toString()));
    }
  }
}
