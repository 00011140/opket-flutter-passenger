import 'package:dartz/dartz.dart';
import 'package:opket/core/failure/failure.dart';
import 'package:opket/feat/ride_booking/domain/repo/ride_booking_repo.dart';

import 'ride_booking_remote_datasource.dart';

class RideBookingRepoImpl implements RideBookingRepo {
  final RideBookingRemoteDatasource remoteDataSource;

  RideBookingRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> cancelRide(params) async {
    try {
      await remoteDataSource.cancelRide(params);
      return Right(null);
    } catch (e) {
      return Left(
        GeneralFailure("Buyurtmani bekor qilishda xatolik yuz berdi"),
      );
    }
  }

  @override
  Future<Either<Failure, String>> requestRide(params) async {
    try {
      final result = await remoteDataSource.requestRide(params);
      return Right(result);
    } catch (e) {
      return Left(GeneralFailure("Taksi chaqisihisda xatolik yuz berdi"));
    }
  }
}
