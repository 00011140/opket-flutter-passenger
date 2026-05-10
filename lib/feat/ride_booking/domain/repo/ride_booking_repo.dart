import 'package:dartz/dartz.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/feat/ride_booking/data/ride_booking_remote_datasource.dart';
import 'package:opket/feat/ride_booking/domain/usecases/cancel_ride.dart';
import 'package:opket/feat/ride_booking/domain/usecases/request_ride.dart';

abstract class RideBookingRepo {
  Future<Either<Failure, RideRequestResult>> requestRide(RequestRideParams params);
  Future<Either<Failure, void>> cancelRide(CancelRideParams params);
}
