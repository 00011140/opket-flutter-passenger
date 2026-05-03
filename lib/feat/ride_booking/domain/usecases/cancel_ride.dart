import 'package:dartz/dartz.dart';
import 'package:opket/core/config/usecase.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/feat/ride_booking/domain/repo/ride_booking_repo.dart';

class CancelRide extends UseCase<void, CancelRideParams> {
  final RideBookingRepo repository;

  CancelRide(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.cancelRide(params);
  }
}

class CancelRideParams {
  final String rideId;

  CancelRideParams({required this.rideId});
}
