part of '../../index.dart';

class GetRideOptions extends UseCase<List<RideOption>, NoParams> {
  final RideOptionsRepo repository;

  GetRideOptions(this.repository);

  @override
  Future<dartz.Either<Failure, List<RideOption>>> call(params) async {
    return await repository.getRideOptions();
  }
}
