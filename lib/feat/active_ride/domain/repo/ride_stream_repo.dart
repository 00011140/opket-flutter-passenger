part of '../../index.dart';

abstract class RideStreamRepository {
  Future<Either<Failure, RideModel>> getCurrentRide(
    GetCurrentRideParams params,
  );
  Stream<RideEvent> get events;
}
