part of '../index.dart';

class RideOptionsRepoImpl implements RideOptionsRepo {
  final RideOptionsRemoteDatasource remoteDataSource;
  final RideOptionsLocalDatasource localDataSource;

  RideOptionsRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<dartz.Either<Failure, List<RideOption>>> getRideOptions() async {
    try {
      final resultCached = await localDataSource.getRideOptions();
      await remoteDataSource.getRideOptions();

      return dartz.Right(resultCached);
    } catch (e) {
      return dartz.Left(
        GeneralFailure("Buyurtmani bekor qilishda xatolik yuz berdi"),
      );
    }
  }
}
