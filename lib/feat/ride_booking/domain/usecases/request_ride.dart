import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opket/core/config/usecase.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/feat/ride_booking/data/ride_booking_remote_datasource.dart';
import 'package:opket/feat/ride_booking/domain/repo/ride_booking_repo.dart';

class RequestRide extends UseCase<RideRequestResult, RequestRideParams> {
  final RideBookingRepo repository;

  RequestRide(this.repository);

  @override
  Future<Either<Failure, RideRequestResult>> call(params) async {
    return await repository.requestRide(params);
  }
}

class RequestRideParams {
  final LatLng location;
  final List<String> options;

  RequestRideParams({required this.location, required this.options});
}
