part of '../../index.dart';

class RideOptionsCubit extends Cubit<RideOptionsState> {
  final GetRideOptions getRideOptionsUsecase;

  RideOptionsCubit({required this.getRideOptionsUsecase})
    : super(RideOptionsInitial());

  void getRideOptions() async {
    try {
      emit(RideOptionsLoading());
      final result = await getRideOptionsUsecase(NoParams());

      emit(
        result.fold(
          (l) => RideOptionsError(message: l.message),
          (r) => RideOptionsSuccess(options: r),
        ),
      );
    } catch (e) {
      emit(RideOptionsError(message: e.toString()));
    }
  }

  void reset() {
    emit(RideOptionsInitial());
  }
}
