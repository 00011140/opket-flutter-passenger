part of '../../index.dart';

abstract class RideStreamRepository {
  Future<Either<Failure, RideModel>> getCurrentRide(
    GetCurrentRideParams params,
  );
  Stream<RideEvent> get events;
  Future<void> setUseBalance({required String rideId, required bool useBalance});
  Future<void> rateRide({required String rideId, required int rating, String? comment});
}
