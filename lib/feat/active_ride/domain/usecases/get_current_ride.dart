part of '../../index.dart';

class GetCurrentRide extends UseCase<RideModel, GetCurrentRideParams> {
  final RideStreamRepository repository;

  GetCurrentRide(this.repository);

  @override
  Future<Either<Failure, RideModel>> call(params) async {
    return await repository.getCurrentRide(params);
  }
}

class GetCurrentRideParams {
  final String rideId;

  GetCurrentRideParams({required this.rideId});
}
