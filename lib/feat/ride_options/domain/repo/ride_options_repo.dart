part of '../../index.dart';

abstract class RideOptionsRepo {
  Future<dartz.Either<Failure, List<RideOption>>> getRideOptions();
}
